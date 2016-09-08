//
//  GetFacultyService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/21/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

class GetFacultyService: BaseDataService {

    class func getFaculties(completionHandler: (([FacultiesEntity]?, NSError?) -> Void)!) {

        getFaculties(.CachedElseLoad, completionHandler: completionHandler)
    }

    class func getFaculties(cache: CachePolicy, completionHandler: (([FacultiesEntity]?, NSError?) -> Void)!) {

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let date = userDefaults.objectForKey("FacultiesKey") as? NSDate
        let expiryDate = date?.dateByAddingTimeInterval(FacultiesCacheTimeInterval)

        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending) {
            featchFaculties({ (items: [GSItem]?, error: NSError?) -> Void in

                if (items?.count > 0) {
                    self.storeFaculties(items!, completionHandler: { () -> Void in
                        userDefaults.setObject(NSDate(), forKey: "FacultiesKey")
                        userDefaults.synchronize()
                        self.featchFacultiesFromCache(completionHandler)
                    })
                } else {
                    self.featchFacultiesFromCache(completionHandler)
                }
            })
        } else {
            featchFacultiesFromCache(completionHandler)
        }
    }

    class func featchFaculties(completionHandler: (([GSItem]?, NSError?) -> Void)!) {
        let path = "/getFaculties"

        resumeRequest(path, queryItems: nil, completionHandler: { result in

            if case .Success(let dict) = result, let items = dict["items"] as? [NSDictionary] {

                var res: [GSItem] = Array()
                for item in items {

                    var title = item["title"] as! String
                    title = title.stringByReplacingOccurrencesOfString("^Факультет ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)

                    // TODO:
//                    let nsRange = Range<String.Index>(start: advance(title.startIndex, 0), end: advance(title.startIndex, 1))
//                    title = title.stringByReplacingCharactersInRange(nsRange, withString: title.substringToIndex(advance(title.startIndex, 1)).capitalizedString)

                    let gsItem = GSItem(item["id"] as! String, title)
                    res.append(gsItem)
                }
                completionHandler(res, nil)

            } else if case let .Failure(error) = result {

                completionHandler(nil, error)
            }
        })
    }

    class func featchFacultiesFromCache(completionHandler: (([FacultiesEntity]?, NSError?) -> Void)!) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        let context = cdHelper.backgroundContext
        context.performBlock({ () -> Void in

            let request = NSFetchRequest(entityName: FacultiesEntityName)
            request.resultType = .ManagedObjectIDResultType
            let sorter: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sorter]

            let itemIds = try! context.executeFetchRequest(request) as! [NSManagedObjectID]

            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                let items = cdHelper.convertToMainQueue(itemIds) as? [FacultiesEntity]

                completionHandler(items, nil)
            })
        })
    }

    class func storeFaculties(items: [GSItem], completionHandler: (() -> Void)!) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        let context = cdHelper.backgroundContext
        context.performBlock({ () -> Void in

            let request = NSFetchRequest(entityName: FacultiesEntityName)

            let cacheItems = try! context.executeFetchRequest(request) as! [FacultiesEntity]

            var handledItems: [FacultiesEntity] = Array()
            for item in items {

                var oldItem = cacheItems.filter { $0.id == item.id }.first as FacultiesEntity?

                if (oldItem == nil) {
                    let newItem = NSEntityDescription.insertNewObjectForEntityForName(FacultiesEntityName, inManagedObjectContext: context) as! FacultiesEntity

                    newItem.id = item.id
                    newItem.title = item.value

                    oldItem = newItem
                } else {
                    oldItem!.title = item.value
                }
                handledItems.append(oldItem!)
            }

            for item in cacheItems {

                if !handledItems.contains(item) {
                    context.deleteObject(item)
                }
            }

            cdHelper.saveContext(context)

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler()
            })
        })
    }

}

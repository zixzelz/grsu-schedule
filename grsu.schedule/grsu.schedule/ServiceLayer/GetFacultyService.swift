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

    class func getFaculties(completionHandler: ((Array<FacultiesEntity>?, NSError?) -> Void)!) {
        
        getFaculties(true, completionHandler: completionHandler)
    }

    class func getFaculties( useCache: Bool, completionHandler: ((Array<FacultiesEntity>?, NSError?) -> Void)!) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let date = userDefaults.objectForKey("FacultiesKey") as NSDate?
        let expiryDate = date?.dateByAddingTimeInterval(FacultiesCacheTimeInterval)
        
        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending ) {
            featchFaculties({ (items: Array<GSItem>?, error: NSError?) -> Void in
                if (items?.count > 0) {
                    self.storeFaculties(items!, completionHandler: { () -> Void in
                        userDefaults.setObject(NSDate(), forKey: "FacultiesKey")
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

    class func featchFaculties( completionHandler: ((Array<GSItem>?, NSError?) -> Void)!) {
        let path = "/getFaculties"
        
        resumeRequest(path, queryItems: nil, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            var res : [GSItem] = Array()
            if let items = result?["items"] as? [NSDictionary] {
                
                for item in items {
                    var title = item["title"] as String
                    title = title.stringByReplacingOccurrencesOfString("^Факультет ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
                    
                    let nsRange = Range<String.Index>(start: advance(title.startIndex, 0), end: advance(title.startIndex, 1))
                    title = title.stringByReplacingCharactersInRange(nsRange, withString:title.substringToIndex(advance(title.startIndex, 1)).capitalizedString)
                    
                    let gsItem = GSItem(item["id"] as String, title)
                    res.append(gsItem)
                }
                
            }
            
            completionHandler(res, error)
        })
    }

    class func featchFacultiesFromCache(completionHandler: ((Array<FacultiesEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let request = NSFetchRequest(entityName: FacultiesEntityName)
                request.resultType = .ManagedObjectIDResultType
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "id" , ascending: true)
                request.sortDescriptors = [sorter]
                
                var error : NSError?
                let itemIds = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var items : [FacultiesEntity]?
                    if error == nil {
                        items = cdHelper.convertToMainQueue(itemIds) as? [FacultiesEntity]
                    } else {
                        NSLog("executeFetchRequest error: %@", error!)
                    }
                    
                    completionHandler(items, error)
                })
            })
        } else {
            completionHandler(nil, NSError())
        }
        
    }
    
    class func storeFaculties(items: Array<GSItem>, completionHandler: ( () -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let request = NSFetchRequest(entityName: FacultiesEntityName)
                
                var error : NSError?
                let cacheItems = context.executeFetchRequest(request, error: &error) as [FacultiesEntity]
                
                var handledItems: [FacultiesEntity] = Array()
                for item in items {
                    
                    var oldItem = cacheItems.filter { $0.id == item.id }.first as FacultiesEntity?
                    
                    if (oldItem == nil) {
                        var newItem = NSEntityDescription.insertNewObjectForEntityForName(FacultiesEntityName, inManagedObjectContext: context) as FacultiesEntity
                        
                        newItem.id = item.id
                        newItem.title = item.value
                        
                        oldItem = newItem
                    } else {
                        oldItem!.title = item.value
                    }
                    handledItems.append(oldItem!)
                }
                
                for item in cacheItems {
                    
                    if !contains(handledItems, item) {
                        context.deleteObject(item)
                    }
                }
                
                cdHelper.saveContext(context)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler()
                })
            })
        } else {
            completionHandler()
        }
    }

    
}

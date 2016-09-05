//
//  GetDepartmentsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/14/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

typealias GetDepartmentsCompletionHandlet = ServiceResult<[DepartmentsEntity], NSError> -> Void

class GetDepartmentsService: BaseDataService {

    class func getDepartments(completionHandler: GetDepartmentsCompletionHandlet) {
        getDepartments(true, completionHandler: completionHandler)
    }

    class func getDepartments(useCache: Bool, completionHandler: GetDepartmentsCompletionHandlet) {

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let date = userDefaults.objectForKey("DepartmentsKey") as? NSDate
        let expiryDate = date?.dateByAddingTimeInterval(DepartmentsCacheTimeInterval)

        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending) {

            featchDepartments { result -> Void in

                switch result {
                case .Failure: self.featchDepartmentsFromCache(completionHandler)
                case .Success(let items):

                    if items.count > 0 {

                        self.storeDepartments(items, completionHandler: { () -> Void in

                            userDefaults.setObject(NSDate(), forKey: "DepartmentsKey")
                            userDefaults.synchronize()
                            self.featchDepartmentsFromCache(completionHandler)
                        })
                    } else {
                        self.featchDepartmentsFromCache(completionHandler)
                    }
                }
            }
        } else {
            featchDepartmentsFromCache(completionHandler)
        }
    }

    class func featchDepartments(completionHandler: (ServiceResult<[GSItem], NSError> -> Void)) {
        let path = "/getDepartments"

        resumeRequest(path, queryItems: nil) { result in

            switch result {
            case .Failure(let error): completionHandler(.Failure(error))
            case .Success(let dict):
                let items = dict["items"] as? [[String: AnyObject]] ?? [[:]]
                let res = items.map { GSItem($0["id"] as! String, $0["title"] as! String) }
                completionHandler(.Success(res))
            }
        }
    }

    class func featchDepartmentsFromCache(completionHandler: GetDepartmentsCompletionHandlet) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh

        let context = cdHelper.backgroundContext

        context.performBlock { _ in

            let sorter: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true)

            let request = NSFetchRequest(entityName: DepartmentsEntityName)
            request.resultType = .ManagedObjectIDResultType
            request.sortDescriptors = [sorter]

            do {
                let itemIds = try context.executeFetchRequest(request) as! [NSManagedObjectID]

                dispatch_async(dispatch_get_main_queue(), { _ in

                    let items = cdHelper.convertToMainQueue(itemIds) as! [DepartmentsEntity]
                    completionHandler(.Success(items))
                })
            }
            catch let error as NSError {

                NSLog("executeFetchRequest error: \(error)")
                completionHandler(.Failure(error))
            }
        }
    }

    class func storeDepartments(items: [GSItem], completionHandler: (() -> Void)!) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh

        let context = cdHelper.backgroundContext
        context.performBlock { _ in

            let request = NSFetchRequest(entityName: DepartmentsEntityName)
            let cacheItems = try! context.executeFetchRequest(request) as! [DepartmentsEntity]

            var handledItems = [DepartmentsEntity]()
            for item in items {

                if let oldItem = cacheItems.filter({ $0.id == item.id }).first {

                    oldItem.title = item.value
                    handledItems.append(oldItem)
                } else {

                    let newItem = NSEntityDescription.insertNewObjectForEntityForName(DepartmentsEntityName, inManagedObjectContext: context) as! DepartmentsEntity

                    newItem.id = item.id
                    newItem.title = item.value

                    handledItems.append(newItem)
                }
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
        }
    }

}
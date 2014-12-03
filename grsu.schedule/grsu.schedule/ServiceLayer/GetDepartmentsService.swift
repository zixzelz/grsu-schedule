//
//  GetDepartmentsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/14/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

class GetDepartmentsService: BaseDataService {
   
    class func getDepartments(completionHandler: ((Array<DepartmentsEntity>?, NSError?) -> Void)!) {
        getDepartments(true, completionHandler: completionHandler)
    }
    
    class func getDepartments( useCache: Bool, completionHandler: ((Array<DepartmentsEntity>?, NSError?) -> Void)!) {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let date = userDefaults.objectForKey("DepartmentsKey") as NSDate?
        let expiryDate = date?.dateByAddingTimeInterval(DepartmentsCacheTimeInterval)
        
        if (useCache == false || expiryDate == nil || expiryDate!.compare(NSDate()) == .OrderedAscending ) {
            featchDepartments({ (items: Array<GSItem>?, error: NSError?) -> Void in
                if (items?.count > 0) {
                    self.storeDepartments(items!, completionHandler: { () -> Void in
                        userDefaults.setObject(NSDate(), forKey: "DepartmentsKey")
                        self.featchDepartmentsFromCache(completionHandler)
                    })
                } else {
                    self.featchDepartmentsFromCache(completionHandler)
                }
            })
        } else {
            featchDepartmentsFromCache(completionHandler)
        }
    
    }
    
    class func featchDepartments(completionHandler: ((Array<GSItem>?, NSError?) -> Void)!) {
        let path = "/getDepartments"
        
        resumeRequest(path, queryItems: nil, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            var res : [GSItem] = Array()
            if let items = result?["items"] as? [NSDictionary] {
                
                for item in items {
                    let gsItem = GSItem(item["id"] as String, item["title"] as String)
                    res.append(gsItem)
                }
                
            }
            
            completionHandler(res, error)
        })
    }
    
    class func featchDepartmentsFromCache(completionHandler: ((Array<DepartmentsEntity>?, NSError?) -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
                
                let request = NSFetchRequest(entityName: DepartmentsEntityName)
                request.resultType = .ManagedObjectIDResultType
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "id" , ascending: true)
                request.sortDescriptors = [sorter]
                
                var error : NSError?
                let itemIds = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var items : [DepartmentsEntity]?
                    if error == nil {
                        items = cdHelper.convertToMainQueue(itemIds) as? [DepartmentsEntity]
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

    class func storeDepartments(items: Array<GSItem>, completionHandler: ( () -> Void)!) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ () -> Void in
            
                let request = NSFetchRequest(entityName: DepartmentsEntityName)
                
                var error : NSError?
                let cacheItems = context.executeFetchRequest(request, error: &error) as [DepartmentsEntity]
                
                var handledItems: [DepartmentsEntity] = Array()
                for item in items {
                    
                    var oldItem = cacheItems.filter { $0.id == item.id }.first as DepartmentsEntity?
                    
                    if (oldItem == nil) {
                        var newItem  = NSEntityDescription.insertNewObjectForEntityForName(DepartmentsEntityName, inManagedObjectContext: context) as DepartmentsEntity
                        
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
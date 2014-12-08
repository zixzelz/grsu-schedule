//
//  FavoriteManager.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/7/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

class FavoriteManager: NSObject {
   
    func getFavoriteStudentGroup(completionHandler: ((Array<FavoriteEntity>) -> Void)!) {
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                let request = NSFetchRequest(entityName: FavoriteEntityName)
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "date" , ascending: true)
                request.sortDescriptors = [sorter]
                request.predicate = NSPredicate(format: "(group != nil)")
                
                var error : NSError?
                let itemIds = context.executeFetchRequest(request, error: &error) as [NSManagedObjectID]
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var items : [FavoriteEntity]?
                    if error == nil {
                        items = cdHelper.convertToMainQueue(itemIds) as? [FavoriteEntity]
                    } else {
                        NSLog("executeFetchRequest error: %@", error!)
                    }
                    
                    completionHandler(items!)
                })
            })
        } else {
            completionHandler([])
        }
    }
    
    func addFavorite(group: GroupsEntity) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                let group_ = context.objectWithID(group.objectID) as GroupsEntity
                
                var newItem = NSEntityDescription.insertNewObjectForEntityForName(FavoriteEntityName, inManagedObjectContext: context) as FavoriteEntity
                newItem.group = group_;
                newItem.synchronizeCalendar = false

                cdHelper.saveContext(context)
            })
        }
    }
    
    func removeFavorite(item: FavoriteEntity) {
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                let item_ = context.objectWithID(item.objectID) as FavoriteEntity
                
                 context.deleteObject(item_)
                 cdHelper.saveContext(context)
            })
        }
    }
    
}

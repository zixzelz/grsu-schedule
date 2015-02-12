//
//  FavoriteManager.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/7/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

let GSFavoriteManagerFavoritWillRemoveNotificationKey = "GSFavoriteManagerFavoritWillRemoveNotificationKey" // userInfo contains FavoriteEntity
let GSFavoriteManagerFavoriteObjectKey = "GSFavoriteManagerFavoriteObjectKey"

class FavoriteManager: NSObject {
   
    func getAllFavorite(completionHandler: ((Array<FavoriteEntity>) -> Void)!) {
        
        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                var sorter: NSSortDescriptor = NSSortDescriptor(key: "order" , ascending: true)
                
                let request = NSFetchRequest(entityName: FavoriteEntityName)
                request.resultType = .ManagedObjectIDResultType
                request.sortDescriptors = [sorter]
//                request.predicate = NSPredicate(format: "(group != nil)")
                
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
        Flurry.logEvent("add favorite group", withParameters: ["group": group.title])

        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                let lastOrder = self.getMaxOrder(context)
                let group_ = context.objectWithID(group.objectID) as GroupsEntity
                
                var newItem = NSEntityDescription.insertNewObjectForEntityForName(FavoriteEntityName, inManagedObjectContext: context) as FavoriteEntity
                newItem.group = group_;
                newItem.synchronizeCalendar = false
                newItem.order = lastOrder+1

                cdHelper.saveContext(context)
            })
        }
    }
    
    func addFavorite(teacher: TeacherInfoEntity) {
        Flurry.logEvent("add favorite teacher", withParameters: ["teacher": teacher.title!])

        let delegate = UIApplication.sharedApplication().delegate as AppDelegate
        let cdHelper = delegate.cdh
        if let context = cdHelper.backgroundContext {
            context.performBlock({ _ in
                
                let lastOrder = self.getMaxOrder(context)
                let teacher_ = context.objectWithID(teacher.objectID) as TeacherInfoEntity
                
                var newItem = NSEntityDescription.insertNewObjectForEntityForName(FavoriteEntityName, inManagedObjectContext: context) as FavoriteEntity
                newItem.teacher = teacher_;
                newItem.synchronizeCalendar = false
                newItem.order = lastOrder+1
                
                cdHelper.saveContext(context)
            })
        }
    }

    func removeFavorite(item: FavoriteEntity) {
        
        if let group = item.group {
            Flurry.logEvent("remove favorite group", withParameters: ["group": group.title])
        } else if let teacher = item.teacher {
            Flurry.logEvent("remove favorite teacher", withParameters: ["teacher": teacher.title!])
        }
    
        NSNotificationCenter.defaultCenter().postNotificationName(GSFavoriteManagerFavoritWillRemoveNotificationKey, object: nil, userInfo: ["GSFavoriteManagerFavoriteObjectKey": item])
        
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
    
    // MARK: - Utils

    func getMaxOrder(context: NSManagedObjectContext) -> Int {
        let request = NSFetchRequest(entityName: FavoriteEntityName)
        var sorter: NSSortDescriptor = NSSortDescriptor(key: "order" , ascending: false)
        request.sortDescriptors = [sorter]
        request.fetchLimit = 1;
        
        var error : NSError?
        let items = context.executeFetchRequest(request, error: &error) as [FavoriteEntity]
        let lastOrder = items.last?.order.integerValue ?? -1

        return lastOrder
    }
    
}

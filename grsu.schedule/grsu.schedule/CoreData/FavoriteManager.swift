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

    func getAllFavorite(completionHandler: (([FavoriteEntity]) -> Void)!) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        let context = cdHelper.backgroundContext
        context.performBlock { _ in

            let sorter: NSSortDescriptor = NSSortDescriptor(key: "order", ascending: true)

            let request = NSFetchRequest(entityName: FavoriteEntityName)
            request.resultType = .ManagedObjectIDResultType
            request.sortDescriptors = [sorter]
//                request.predicate = NSPredicate(format: "(group != nil)")

            let itemIds = try! context.executeFetchRequest(request) as! [NSManagedObjectID]
            dispatch_async(dispatch_get_main_queue(), { _ in

                let items = cdHelper.convertToMainQueue(itemIds) as! [FavoriteEntity]
                completionHandler(items)
            })
        }
    }

    func addFavoriteWithGroup(group: GroupsEntity) {
        Flurry.logEvent("add favorite group", withParameters: ["group": group.title])

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        let context = cdHelper.backgroundContext
        context.performBlock({ _ in

            let lastOrder = self.getMaxOrder(context)
            let group_ = context.objectWithID(group.objectID) as! GroupsEntity

            let newItem = NSEntityDescription.insertNewObjectForEntityForName(FavoriteEntityName, inManagedObjectContext: context) as! FavoriteEntity
            newItem.group = group_;
            newItem.synchronizeCalendar = false
            newItem.order = lastOrder + 1

            cdHelper.saveContext(context)
        })
    }

    func addFavorite(teacher: TeacherInfoEntity) {

        Flurry.logEvent("add favorite teacher", withParameters: ["teacher": teacher.title!])

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        let context = cdHelper.backgroundContext
        context.performBlock({ _ in

            let lastOrder = self.getMaxOrder(context)
            let teacher_ = context.objectWithID(teacher.objectID) as! TeacherInfoEntity

            let newItem = NSEntityDescription.insertNewObjectForEntityForName(FavoriteEntityName, inManagedObjectContext: context) as! FavoriteEntity
            newItem.teacher = teacher_;
            newItem.synchronizeCalendar = false
            newItem.order = lastOrder + 1

            cdHelper.saveContext(context)
        })
    }

    func removeFavorite(item: FavoriteEntity) {

        if let group = item.group {
            Flurry.logEvent("remove favorite group", withParameters: ["group": group.title])
        } else if let teacher = item.teacher {
            Flurry.logEvent("remove favorite teacher", withParameters: ["teacher": teacher.title!])
        }

        NSNotificationCenter.defaultCenter().postNotificationName(GSFavoriteManagerFavoritWillRemoveNotificationKey, object: nil, userInfo: ["GSFavoriteManagerFavoriteObjectKey": item])

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let cdHelper = delegate.cdh
        let context = cdHelper.backgroundContext
        context.performBlock({ _ in

            let item_ = context.objectWithID(item.objectID) as! FavoriteEntity

            context.deleteObject(item_)
            cdHelper.saveContext(context)
        })
    }

    // MARK: - Utils

    func getMaxOrder(context: NSManagedObjectContext) -> Int {

        let request = NSFetchRequest(entityName: FavoriteEntityName)
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "order", ascending: false)
        request.sortDescriptors = [sorter]
        request.fetchLimit = 1;

        let items = try! context.executeFetchRequest(request) as! [FavoriteEntity]
        let lastOrder = items.last?.order.integerValue ?? -1

        return lastOrder
    }

}

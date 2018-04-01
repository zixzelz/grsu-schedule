//
//  FavoriteManager.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/7/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData
import Flurry_iOS_SDK

let GSFavoriteManagerFavoritWillRemoveNotificationKey = "GSFavoriteManagerFavoritWillRemoveNotificationKey" // userInfo contains FavoriteEntity
let GSFavoriteManagerFavoriteObjectKey = "GSFavoriteManagerFavoriteObjectKey"

class FavoriteManager: NSObject {

    func getAllFavorite(_ completionHandler: @escaping (([FavoriteEntity]) -> Void)) {

        let context = CoreDataHelper.backgroundContext
        context.perform {

            let sorter: NSSortDescriptor = NSSortDescriptor(key: "order", ascending: true)

            let request = NSFetchRequest<NSFetchRequestResult>(entityName: FavoriteEntityName)
            request.resultType = .managedObjectIDResultType
            request.sortDescriptors = [sorter]
//                request.predicate = NSPredicate(format: "(group != nil)")

            guard let res = try? context.fetch(request), let itemIds = res as? [NSManagedObjectID] else {
                DispatchQueue.main.async {
                    completionHandler([])
                }
                return
            }
            DispatchQueue.main.async {
                let items = CoreDataHelper.convertToMainQueue(itemIds) as! [FavoriteEntity]
                completionHandler(items)
            }
        }
    }

    func addFavoriteWithGroup(_ group: GroupsEntity) {
        Flurry.logEvent("add favorite group", withParameters: ["group": group.title])

        let context = CoreDataHelper.backgroundContext
        context.perform({

            let lastOrder = FavoriteManager.getMaxOrder(context)
            let group_ = context.object(with: group.objectID) as! GroupsEntity

            let newItem = NSEntityDescription.insertNewObject(forEntityName: FavoriteEntityName, into: context) as! FavoriteEntity
            newItem.group = group_
            newItem.synchronizeCalendar = false
            newItem.order = NSNumber(value: lastOrder + 1)

            CoreDataHelper.saveContext(context)
        })
    }

    func addFavorite(_ teacher: TeacherInfoEntity) {

        // todo: make enum with type of events in a future
        Flurry.logEvent("add favorite teacher", withParameters: ["teacher": teacher.displayTitle])

        let context = CoreDataHelper.backgroundContext
        context.perform({

            let lastOrder = FavoriteManager.getMaxOrder(context)
            let teacher_ = context.object(with: teacher.objectID) as! TeacherInfoEntity

            let newItem = NSEntityDescription.insertNewObject(forEntityName: FavoriteEntityName, into: context) as! FavoriteEntity
            newItem.teacher = teacher_
            newItem.synchronizeCalendar = false
            newItem.order = NSNumber(value: lastOrder + 1)

            CoreDataHelper.saveContext(context)
        })
    }

    func removeFavorite(_ item: FavoriteEntity) {

        if let group = item.group {
            Flurry.logEvent("remove favorite group", withParameters: ["group": group.title])
        } else if let teacher = item.teacher {
            Flurry.logEvent("remove favorite teacher", withParameters: ["teacher": teacher.title!])
        }

        NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: GSFavoriteManagerFavoritWillRemoveNotificationKey), object: nil, userInfo: ["GSFavoriteManagerFavoriteObjectKey": item])

        let context = CoreDataHelper.backgroundContext
        context.perform({

            let item_ = context.object(with: item.objectID) as! FavoriteEntity

            context.delete(item_)
            CoreDataHelper.saveContext(context)
        })
    }

    // MARK: - Utils

    private static func getMaxOrder(_ context: NSManagedObjectContext) -> Int {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: FavoriteEntityName)
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "\(#keyPath(FavoriteEntity.order))", ascending: false)
        request.sortDescriptors = [sorter]
        request.fetchLimit = 1

        let items = try! context.fetch(request) as! [FavoriteEntity]
        let lastOrder = items.last?.order.intValue ?? -1

        return lastOrder
    }

}

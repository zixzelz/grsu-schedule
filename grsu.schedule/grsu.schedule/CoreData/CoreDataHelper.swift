//
//  CoreDataHelper.swift
//  SwiftCoreDataSimpleDemo
//
//  Created by CHENHAO on 14-6-7.
//  Copyright (c) 2014 CHENHAO. All rights reserved.
//

import CoreData
import UIKit

class CoreDataHelper: NSObject {

    let store: CoreDataStore!

    override init() {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        store = appDelegate.cdstore

        super.init()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CoreDataHelper.contextDidSaveContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // #pragma mark - Core Data stack

    // Returns the managed object context for the application.
    // Normally, you can use it to do anything.
    // But for bulk data update, acording to Florian Kugler's blog about core data performance, [Concurrent Core Data Stacks – Performance Shootout](http://floriankugler.com/blog/2013/4/29/concurrent-core-data-stack-performance-shootout) and [Backstage with Nested Managed Object Contexts](http://floriankugler.com/blog/2013/5/11/backstage-with-nested-managed-object-contexts). We should better write data in background context. and read data from main queue context.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

    // main thread context

    lazy var managedObjectContext: NSManagedObjectContext = {

        let coordinator = self.store.persistentStoreCoordinator

        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator

        return managedObjectContext
    }()

    // Returns the background object context for the application.
    // You can use it to process bulk data update in background.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

    lazy var backgroundContext: NSManagedObjectContext = {

        let coordinator = self.store.persistentStoreCoordinator

        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator

        return backgroundContext
    }()

    // save NSManagedObjectContext
    func saveContext(context: NSManagedObjectContext) {

        context.saveIfNeeded()
    }

    func saveContext() {
        saveContext(self.backgroundContext)
    }

    func convertToMainQueue(itemIds: [NSManagedObjectID]) -> [AnyObject] {
        let mainContext = managedObjectContext

        var items = [AnyObject]()
        for objId in itemIds {

            let obj = mainContext.objectWithID(objId)
            items.append(obj)
        }
        return items
    }

    // call back function by saveContext, support multi-thread
    func contextDidSaveContext(notification: NSNotification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.managedObjectContext {
            // NSLog("******** Saved main Context in this thread")
            self.backgroundContext.performBlock {
                self.backgroundContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        } else if sender === self.backgroundContext {
            // NSLog("******** Saved background Context in this thread")
            self.managedObjectContext.performBlock {
                self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            }
        } else {
            // NSLog("******** Saved Context in other thread")
        }
    }
}

extension NSManagedObjectContext {

    func saveIfNeeded() {

        do {
            if hasChanges {
                try save()
            }
        } catch {

            NSLog("Unresolved error \(error)")
            abort()
        }
    }
}
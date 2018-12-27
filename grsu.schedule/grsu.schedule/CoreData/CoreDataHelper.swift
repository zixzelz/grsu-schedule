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

    private let store: CoreDataStore

    private static let sharedInstance = CoreDataHelper()

    override init() {

        store = CoreDataStore()

        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(CoreDataHelper.contextDidSaveContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    private func setup() {
        managedObjectContext.saveIfNeeded()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    static var managedObjectContext: NSManagedObjectContext {
        return sharedInstance.managedObjectContext
    }

    static var backgroundContext: NSManagedObjectContext {
        return sharedInstance.backgroundContext
    }

    class func saveBackgroundContext() {
        saveContext(sharedInstance.backgroundContext)
    }

    class func saveContext(_ context: NSManagedObjectContext) {
        context.saveIfNeeded()
    }

    class func convertToMainQueue(_ itemIds: [NSManagedObjectID]) -> [AnyObject] {
        return sharedInstance.convertToMainQueue(itemIds)
    }

    // #pragma mark - Core Data stack

    // Returns the managed object context for the application.
    // Normally, you can use it to do anything.
    // But for bulk data update, acording to Florian Kugler's blog about core data performance, [Concurrent Core Data Stacks – Performance Shootout](http://floriankugler.com/blog/2013/4/29/concurrent-core-data-stack-performance-shootout) and [Backstage with Nested Managed Object Contexts](http://floriankugler.com/blog/2013/5/11/backstage-with-nested-managed-object-contexts). We should better write data in background context. and read data from main queue context.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

    // main thread context

    lazy var managedObjectContext: NSManagedObjectContext = {

        let coordinator = store.persistentStoreCoordinator

        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator

        return managedObjectContext
    }()

    // Returns the background object context for the application.
    // You can use it to process bulk data update in background.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

    lazy var backgroundContext: NSManagedObjectContext = {

        let coordinator = store.persistentStoreCoordinator

        var backgroundContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        backgroundContext.persistentStoreCoordinator = coordinator

        return backgroundContext
    }()

    // save NSManagedObjectContext
    func saveContext(_ context: NSManagedObjectContext) {

        context.saveIfNeeded()
    }

    func saveBackgroundContext() {
        saveContext(backgroundContext)
    }

    func convertToMainQueue(_ itemIds: [NSManagedObjectID]) -> [AnyObject] {
        let mainContext = managedObjectContext

        var items = [AnyObject]()
        for objId in itemIds {

            let obj = mainContext.object(with: objId)
            items.append(obj)
        }
        return items
    }

    // call back function by saveContext, support multi-thread
    @objc func contextDidSaveContext(_ notification: Foundation.Notification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === managedObjectContext {
            // NSLog("******** Saved main Context in this thread")
            backgroundContext.perform {
                self.backgroundContext.mergeChanges(fromContextDidSave: notification)
            }
        } else if sender === backgroundContext {
            // NSLog("******** Saved background Context in this thread")
            managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        } else {
            // NSLog("******** Saved Context in other thread")
        }
    }
}

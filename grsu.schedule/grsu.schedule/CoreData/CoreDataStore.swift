//
//  CoreDataStore.swift
//  SwiftCoreDataSimpleDemo
//
//  Created by CHENHAO on 14-7-9.
//  Copyright (c) 2014 CHENHAO. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStore: NSObject {

    let storeName = "CoreData"
    let storeFilename = "CoreData.sqlite"

    lazy var applicationDocumentsDirectory: NSURL = {

        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {

        let modelURL = NSBundle.mainBundle().URLForResource(self.storeName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {

        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent(self.storeFilename)

        let store = try? coordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        if store == nil {
            NSLog("Unresolved error")
            abort()
        }
        return coordinator!
    }()
}
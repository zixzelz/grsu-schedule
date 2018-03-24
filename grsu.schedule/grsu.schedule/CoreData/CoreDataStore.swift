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

    lazy var applicationDocumentsDirectory: URL = {

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {

        let modelURL = Bundle.main.url(forResource: storeName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {

        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent(storeFilename)

        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            try coordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch let error as NSError {

            NSLog("Unresolved error \(error)")
            abort()
        }
        return coordinator!
    }()
}

//
//  CoreDataHelper+ServiceLayerSDK.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 10/12/2018.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData
import ServiceLayerSDK

extension CoreDataHelper {
    
    struct ContextProviderObj: ContextProvider {
        var workingContext: ManagedObjectContextType
        var mainContext: ManagedObjectContextType
    }
    
    static func contextProvider() -> ContextProvider {
        return ContextProviderObj(workingContext: backgroundContext, mainContext: managedObjectContext)
    }
}

extension NSManagedObjectContext: ManagedObjectContextType {
    
    public func saveIfNeeded() {
        
        do {
            if hasChanges {
                try save()
            }
        } catch {
            
            print("Unresolved error \(error)")
            abort()
        }
    }
}

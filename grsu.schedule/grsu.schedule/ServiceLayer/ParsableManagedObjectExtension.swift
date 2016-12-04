//
//  ParsableManagedObjectExtension.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 10/18/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObjectContext: ManagedObjectContextType {

}

extension ManagedObjectType {

    public static func managedObjectContext() -> ManagedObjectContextType {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return delegate.cdh.backgroundContext
    }
}

extension ManagedObjectType {

    public static func insert(inContext context: ManagedObjectContextType) -> Self {
        let context = context as! NSManagedObjectContext // TODO: context as generic type?  WARNING
        guard let result: Self = NSEntityDescription.insertNewObjectForEntityForName(String(Self), inManagedObjectContext: context) as? Self else {

            fatalError("Unable to insert \(String(self)) in context./n Check if module for Entity is set properly in CoreData model")
        }
        return result
    }

    public static func objectsMap(withPredicate predicate: NSPredicate?, inContext context: ManagedObjectContextType, sortBy: [NSSortDescriptor]?) -> [String: Self]? {

        guard let cacheItems = objects(withPredicate: predicate, inContext: context, sortBy: sortBy) else {
            return nil
        }
        let cacheItemsMap = cacheItems.dict { ($0.identifier ?? NSUUID().UUIDString, $0) }
        return cacheItemsMap
    }

    public static func objects(withPredicate predicate: NSPredicate?, inContext context: ManagedObjectContextType, sortBy: [NSSortDescriptor]?) -> [Self]? {

        let request = NSFetchRequest(entityName: String(self))
        request.predicate = predicate
        request.sortDescriptors = sortBy

        let result: [Self]? = objects(withRequest: request, inContext: context)
        return result
    }

    public static func objectsForMainQueue(withPredicate predicate: NSPredicate?, inContext context: ManagedObjectContextType, sortBy: [NSSortDescriptor]? = nil, completion: (items: [Self]) -> Void) {

        let request = NSFetchRequest(entityName: String(self))
        request.resultType = .ManagedObjectIDResultType
        request.predicate = predicate
        request.sortDescriptors = sortBy

        let ids: [NSManagedObjectID] = objects(withRequest: request, inContext: context) ?? []

        dispatch_async(dispatch_get_main_queue(), { _ in

            let items = self.convertToMainQueue(ids)

            completion(items: items)
        })
    }

    private static func objects<T: AnyObject>(withRequest request: NSFetchRequest, inContext context: ManagedObjectContextType) -> [T]? {

        var result: [T]? = nil
        do {
            let context = context as! NSManagedObjectContext // WARNING
            result = try context.executeFetchRequest(request) as? [T]
        } catch let error {
            print("\(error)")
            assertionFailure("\(error)")
        }
        return result
    }

    private static func convertToMainQueue(itemIds: [NSManagedObjectID]) -> [Self] {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mainContext = delegate.cdh.managedObjectContext

        let items = itemIds.map { mainContext.objectWithID($0) } as [AnyObject]
        return items as! [Self]
    }

    public func delete(context: ManagedObjectContextType) {

        let context = context as! NSManagedObjectContext // WARNING
        context.deleteObject(self as! NSManagedObject)
    }

}

protocol ManagedObjectConveniance {
    var objectID: NSManagedObjectID { get }
}

extension NSManagedObject: ManagedObjectConveniance { }
extension ManagedObjectConveniance {

    func convertInContext(context: NSManagedObjectContext) -> Self {

        let object = context.objectWithID(objectID)
        return object as! Self
    }

}

//
//  ManagedObjectType.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/6/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

public protocol ManagedObjectType: class {
    var identifier: String { get }
}

extension ManagedObjectType {

    public static func insert(inContext context: NSManagedObjectContext) -> Self {
        guard let result: Self = (NSEntityDescription.insertNewObjectForEntityForName(String(Self), inManagedObjectContext: context) as? Self) else {

            print("Unable to insert \(String(self)) in context./n Check if module for Entity is set properly in CoreData model")
            abort()
        }
        return result
    }

    public static func objects(withPredicate predicate: NSPredicate? = nil, inContext context: NSManagedObjectContext, sortBy: [NSSortDescriptor]? = nil) -> [Self]? {

        let request = NSFetchRequest(entityName: String(self))
        request.predicate = predicate

        let result: [Self]? = objects(withRequest: request, inContext: context)
        return result
    }

    public static func objectsForMainQueue(withPredicate predicate: NSPredicate? = nil, inContext context: NSManagedObjectContext, sortBy: [NSSortDescriptor]? = nil, completion: (items: [Self]) -> Void) {

        let request = NSFetchRequest(entityName: String(self))
        request.resultType = .ManagedObjectIDResultType
        request.predicate = predicate

        let ids: [NSManagedObjectID] = objects(withRequest: request, inContext: context) ?? []

        dispatch_async(dispatch_get_main_queue(), { _ in

            let items = self.convertToMainQueue(ids)

            completion(items: items)
        })
    }

    private static func objects<T: AnyObject>(withRequest request: NSFetchRequest, inContext context: NSManagedObjectContext) -> [T]? {

        var result: [T]? = nil
        do {
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

    public func delete(context: NSManagedObjectContext) {

        context.deleteObject(self as! NSManagedObject)
    }

}
//
//  LocalService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/6/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

protocol LocalServiceQueryType {

    associatedtype QueryInfo: QueryInfoType

    var queryInfo: QueryInfo { get }

    var predicate: NSPredicate? { get }
    var sortBy: [NSSortDescriptor]? { get }
}

extension LocalServiceQueryType {

    var queryInfo: NoneQueryInfo {
        return NoneQueryInfo()
    }
}

class LocalService < T: ModelType > {

    typealias LocalServiceFetchCompletionHandlet = ServiceResult<[T], ServiceError> -> ()
    typealias LocalServiceCompletionHandlet = ServiceResult<Void, ServiceError> -> ()

    var predicate: NSPredicate?
    private lazy var cachedItemsMap: [String: T] = {
        let context = T.managedObjectContext()
        return T.objectsMap(withPredicate: self.predicate, inContext: context) ?? [:]
    }()
    
    private lazy var parsableContext: T.ParsableContext = {
        let context = T.managedObjectContext()
        return T.parsableContext(context)
    }()
    
    func featch < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, completionHandler: LocalServiceFetchCompletionHandlet) {

        let context = T.managedObjectContext()
        context.performBlock { _ in

            T.objectsForMainQueue(withPredicate: query.predicate, inContext: context, sortBy: query.sortBy) { (items) in

                completionHandler(.Success(items))
            }
        }
    }
    
    // json: {"objectsCollection": [{item}, {item}, ...]}
    func parseAndStore < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, json: [String: AnyObject], completionHandler: LocalServiceCompletionHandlet) {
        
        prepareService(query)
        store(query, json: json, completionHandler: completionHandler)
    }

    // json: {item}
    func parseAndStoreItem (json: [String: AnyObject], context: ManagedObjectContextType, queryInfo: T.QueryInfo) throws -> T {
    
        var item: T?
        
        if let keyForIdentifier = T.keyForIdentifier() {
            guard let identifier = json[keyForIdentifier] as? String else {
                throw ServiceError.WrongResponseFormat
            }
            
            item = cachedItemsMap[identifier]
        }
        
        if item != nil {
            item?.update(json, queryInfo: queryInfo)
        } else {
            item = T.insert(inContext: context)
            item?.fill(json, queryInfo: queryInfo, context: parsableContext)
            
            if let identifier = item?.identifier {
                cachedItemsMap[identifier] = item
            }
        }
        return item!
    }
    
    private func prepareService < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery) {
        predicate = query.predicate
    }

    private func store < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, json: [String: AnyObject], completionHandler: LocalServiceCompletionHandlet) {

        guard let items = T.objects(json) else {
            completionHandler(.Failure(.WrongResponseFormat))
            return
        }

        let context = T.managedObjectContext()
        context.performBlock { _ in

            let cachedItemsMap = self.cachedItemsMap
            var handledItemsKey = [String]()
            for item in items {

                do {
                    let newItem = try self.parseAndStoreItem(item, context: context, queryInfo: query.queryInfo)
                    if let identifier = newItem.identifier {
                        handledItemsKey.append(identifier)
                    }
                } catch let error as ServiceError {

                    completionHandler(.Failure(error))
                    return
                } catch {
                    completionHandler(.Failure(.InternalError))
                    return
                }
            }

            let itemForDelete = cachedItemsMap.filter { !handledItemsKey.contains($0.0) }
            for (_, item) in itemForDelete {
                item.delete(context)
            }

            context.saveIfNeeded()
            completionHandler(.Success())
        }
    }
    
    func cleanCache < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, completionHandler: LocalServiceCompletionHandlet) {
        
        let context = T.managedObjectContext()
        context.performBlock { _ in
            
            guard let items = T.objects(withPredicate: query.predicate, inContext: context) else {
                completionHandler(.Failure(.InternalError))
                return
            }
            
            for item in items {
                item.delete(context)
            }
            
            #if DEBUG
                print("Removed cace for: \(items.count) items")
            #endif
            
            context.saveIfNeeded()
            completionHandler(.Success())
        }
    }

}

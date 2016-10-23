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
    typealias LocalServiceStoreCompletionHandlet = ServiceResult<Void, ServiceError> -> ()

    func parseAndStore < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, json: [String: AnyObject], completionHandler: LocalServiceStoreCompletionHandlet) {

        store(query, json: json, completionHandler: completionHandler)
    }

    func featch < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, completionHandler: LocalServiceFetchCompletionHandlet) {

        let context = T.managedObjectContext()

        context.performBlock { _ in

            T.objectsForMainQueue(withPredicate: query.predicate, inContext: context, sortBy: query.sortBy) { (items) in

                completionHandler(.Success(items))
            }
        }
    }

    private func store < LocalServiceQuery: LocalServiceQueryType where LocalServiceQuery.QueryInfo == T.QueryInfo > (query: LocalServiceQuery, json: [String: AnyObject], completionHandler: LocalServiceStoreCompletionHandlet) {

        guard let items = T.objects(json) else {
            completionHandler(.Failure(.WrongResponseFormat))
            return
        }

        let context = T.managedObjectContext()

        context.performBlock { _ in

            let cacheItemsMap = T.objectsMap(withPredicate: query.predicate, inContext: context) ?? [:]
            let parsableContext = T.parsableContext(context)

            var handledItemsKey = [String]()
            for item in items {

                let identifier = item[T.keyForIdentifier()] as! String
                if let oldItem = cacheItemsMap[identifier] {

                    oldItem.update(item, queryInfo: query.queryInfo)
                    handledItemsKey.append(identifier)
                } else {

                    let newItem = T.insert(inContext: context)
                    newItem.fill(item, queryInfo: query.queryInfo, context: parsableContext)
                }
            }

            let itemForDelete = cacheItemsMap.filter { !handledItemsKey.contains($0.0) }
            for (_, item) in itemForDelete {
                item.delete(context)
            }

            context.saveIfNeeded()

            let newcacheItemsMap = T.objectsMap(withPredicate: query.predicate, inContext: context) ?? [:]
            print("newcacheItemsMap \(newcacheItemsMap.keys)")

            completionHandler(.Success())
        }
    }

}

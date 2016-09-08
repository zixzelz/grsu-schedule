//
//  LocalService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/6/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

class LocalService<T: ModelType> {

    typealias LocalServiceFetchCompletionHandlet = ServiceResult<[T], ServiceError> -> ()
    typealias LocalServiceStoreCompletionHandlet = ServiceResult<Void, ServiceError> -> ()

    func parseAndStore(query: NetworkServiceQuery, json: [String: AnyObject], completionHandler: LocalServiceStoreCompletionHandlet) {

        store(query, json: json, completionHandler: completionHandler)
    }

    func featch(query: NetworkServiceQuery, completionHandler: LocalServiceFetchCompletionHandlet) {

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.cdh.backgroundContext

        context.performBlock { _ in

            T.objectsForMainQueue(withPredicate: query.predicate, inContext: context, sortBy: query.sortBy) { (items) in

                completionHandler(.Success(items))
            }
        }
    }

    private func store(query: NetworkServiceQuery, json: [String: AnyObject], completionHandler: LocalServiceStoreCompletionHandlet) {

        guard let items = json[T.keyForEnumerateObjects()] as? [[String: AnyObject]] else {
            completionHandler(.Failure(.WrongResponseFormat))
            return
        }

        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = delegate.cdh.backgroundContext

        context.performBlock { _ in

            let cacheItems = T.objects(withPredicate: query.predicate, inContext: context) ?? []
            let cacheItemsMap = cacheItems.dict { ($0.identifier, $0) }

            var handledItemKeys = [String]()
            for item in items {

                let identifier = item[T.keyForIdentifier()] as! String
                if let oldItem = cacheItemsMap[identifier] {

                    oldItem.fill(item)
                    handledItemKeys.append(identifier)
                } else {

                    let newItem = T.insert(inContext: context)
                    newItem.fill(item)
                    handledItemKeys.append(identifier)
                }
            }

            let itemForDelete = cacheItemsMap.filter { !handledItemKeys.contains($0.0) }
            for (_, item) in itemForDelete {
                item.delete(context)
            }

            context.saveIfNeeded()

            completionHandler(.Success())
        }
    }

}

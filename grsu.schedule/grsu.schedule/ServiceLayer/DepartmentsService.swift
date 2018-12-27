//
//  DepartmentsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/7/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ServiceLayerSDK
import ReactiveSwift

typealias DepartmentsCompletionHandlet = (ServiceResult<[DepartmentsEntity], ServiceError>) -> Void

class DepartmentsService {

    let localService: LocalService<DepartmentsEntity>
    let networkService: NetworkService<DepartmentsEntity>

    init() {
        localService = LocalService(contextProvider: CoreDataHelper.contextProvider())
        networkService = NetworkService(localService: localService)
    }

    func getDepartments(_ cache: CachePolicy = .cachedElseLoad) -> SignalProducer<ServiceResponse<DepartmentsEntity>, ServiceError> {
        return networkService.fetchDataItems(DepartmentsQuery(), cache: cache)
    }

}

class DepartmentsQuery: NetworkServiceQueryType {

    var identifier: String {
        return filterIdentifier
    }

    var queryInfo: DepartmentsQueryInfo { return .default }

    var predicate: NSPredicate? = nil

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "id", ascending: true)]

    var path: String = UrlHost + "/getDepartments"

    var method: NetworkServiceMethod = .GET

    func parameters(range: NSRange?) -> [String: String]? {
        return [
            Parametres.lang.rawValue: Locale.preferredLocale
        ]
    }

}

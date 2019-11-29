//
//  FacultyService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/10/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ServiceLayerSDK
import ReactiveSwift

typealias FacultyCompletionHandlet = (ServiceResult<[FacultiesEntity], ServiceError>) -> Void

class FacultyService {

    let localService: LocalService<FacultiesEntity>
    let networkService: NetworkService<FacultiesEntity>

    init() {
        localService = LocalService(contextProvider: CoreDataHelper.contextProvider())
        networkService = NetworkService(localService: localService)
    }

    func getFaculties(_ cache: CachePolicy = .cachedElseLoad) -> SignalProducer<ServiceResponse<FacultiesEntity>, ServiceError> {
        return networkService.fetchDataItems(FacultyQuery(), cache: cache)
    }

}

class FacultyQuery: NetworkServiceQueryType {

    var identifier: String {
        return filterIdentifier
    }

    var queryInfo: FacultiesQueryInfo {
        return .default
    }

    var path: String = UrlHost + "/getFaculties"

    var method: NetworkServiceMethod = .GET

    func parameters(range: NSRange?) -> [URLQueryItem]? {
        return [
            URLQueryItem(name: Parametres.lang.rawValue, value: Locale.preferredLocale)
        ]
    }

    var predicate: NSPredicate? = nil

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "id", ascending: true)]

}

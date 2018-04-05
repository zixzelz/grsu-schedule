//
//  FacultyService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/10/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

typealias FacultyCompletionHandlet = (ServiceResult<[FacultiesEntity], ServiceError>) -> Void

class FacultyService {

    let localService: LocalService<FacultiesEntity>
    let networkService: NetworkService<FacultiesEntity>

    init() {

        localService = LocalService()
        networkService = NetworkService(localService: localService)
    }

    func getFaculties(_ cache: CachePolicy = .cachedElseLoad, completionHandler: @escaping FacultyCompletionHandlet) {

        networkService.fetchData(FacultyQuery(), cache: cache, completionHandler: completionHandler)
    }

}

class FacultyQuery: NetworkServiceQueryType {
    
    var queryInfo: FacultiesQueryInfo {
        return .default
    }

    var path: String = UrlHost + "/getFaculties"

    var method: NetworkServiceMethod = .GET

    var parameters: [String: Any]? = [
        Parametres.lang.rawValue: Locale.preferredLocale
    ]

    var predicate: NSPredicate? = nil

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "id", ascending: true)]

}

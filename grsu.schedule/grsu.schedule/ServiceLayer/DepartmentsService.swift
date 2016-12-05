//
//  DepartmentsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/7/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

typealias DepartmentsCompletionHandlet = ServiceResult<[DepartmentsEntity], ServiceError> -> Void

class DepartmentsService {

    let localService: LocalService<DepartmentsEntity>
    let networkService: NetworkService<DepartmentsEntity>

    init() {

        localService = LocalService()
        networkService = NetworkService(localService: localService)

        print("init \(networkService)")
    }

    func getDepartments(cache: CachePolicy = .CachedElseLoad, completionHandler: DepartmentsCompletionHandlet) {

        networkService.fetchData(DepartmentsQuery(), cache: cache, completionHandler: completionHandler)
    }

}

class DepartmentsQuery: NetworkServiceQueryType {

    var queryInfo: DepartmentsQueryInfo { return .Default }
    
    var predicate: NSPredicate? = nil

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "id", ascending: true)]

    var path: String = "/getDepartments"

    var method: NetworkServiceMethod = .GET

    var parameters: [String: AnyObject]? = nil

}

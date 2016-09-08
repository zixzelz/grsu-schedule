//
//  DepartmentsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/7/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

typealias DepartmentsCompletionHandlet = ServiceResult<[DepartmentsEntity], LocalServiceError> -> Void

class DepartmentsService {

    let localService: LocalService<DepartmentsEntity>
    let networkService: NetworkService<DepartmentsEntity>

    init() {

        localService = LocalService()
        networkService = NetworkService(localService: localService)

        print("\(networkService)")
    }

    func getDepartments(cache: CachePolicy, completionHandler: DepartmentsCompletionHandlet) {

        networkService.fetchData(DepartmentsQuery(), cache: cache, completionHandler: completionHandler)
    }

}

class DepartmentsQuery: NetworkServiceQuery {

    var path: String {
        return "/getDepartments"
    }
    var method: NetworkServiceMethod {
        return .GET
    }
    var parameters: [String: AnyObject]? = nil

    var predicate: NSPredicate? = nil

    var sortBy: [NSSortDescriptor]? {
        return [NSSortDescriptor(key: "id", ascending: true)]
    }
}
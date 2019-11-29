//
//  GroupsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/10/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ServiceLayerSDK
import ReactiveSwift

typealias GroupsCompletionHandlet = (ServiceResult<[GroupsEntity], ServiceError>) -> Void

class GroupsService {

    let localService: LocalService<GroupsEntity>
    let networkService: NetworkService<GroupsEntity>

    init() {
        localService = LocalService(contextProvider: CoreDataHelper.contextProvider())
        networkService = NetworkService(localService: localService)
    }

    func getGroups(_ faculty: FacultiesEntity, department: DepartmentsEntity, course: String, cache: CachePolicy = .cachedElseLoad) -> SignalProducer<ServiceResponse<GroupsEntity>, ServiceError> {
        let query = GroupsQuery(faculty: faculty, department: department, course: course)
        return networkService.fetchDataItems(query, cache: cache)
    }

}

class GroupsQuery: NetworkServiceQueryType {

    let faculty: FacultiesEntity
    let department: DepartmentsEntity
    let course: String

    init(faculty: FacultiesEntity, department: DepartmentsEntity, course: String) {
        self.faculty = faculty
        self.department = department
        self.course = course
    }

    var identifier: String {
        return filterIdentifier
    }

    var queryInfo: GroupsServiceQueryInfo {
        return .withParams(faculty: faculty, department: department, course: course)
    }

    var path: String = UrlHost + "/getGroups"

    var method: NetworkServiceMethod = .GET

    func parameters(range: NSRange?) -> [URLQueryItem]? {
        return [
            URLQueryItem(name: "facultyId", value: faculty.id),
            URLQueryItem(name: "departmentId", value: department.id),
            URLQueryItem(name: "course", value: course),
            URLQueryItem(name: Parametres.lang.rawValue, value: Locale.preferredLocale)
        ]
    }

    var predicate: NSPredicate? {
        return NSPredicate(format: "(\(#keyPath(GroupsEntity.faculty)) == %@) && (\(#keyPath(GroupsEntity.department)) == %@) && (\(#keyPath(GroupsEntity.course)) == %@) && (\(#keyPath(GroupsEntity.hidden)) == false)", faculty, department, course)
    }

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "\(#keyPath(GroupsEntity.title))", ascending: true)]

}

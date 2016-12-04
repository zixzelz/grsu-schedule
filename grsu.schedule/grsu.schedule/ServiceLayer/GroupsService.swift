//
//  GroupsService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/10/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

typealias GroupsCompletionHandlet = ServiceResult<[GroupsEntity], ServiceError> -> Void

class GroupsService {

    let localService: LocalService<GroupsEntity>
    let networkService: NetworkService<GroupsEntity>

    init() {

        localService = LocalService()
        networkService = NetworkService(localService: localService)
    }

    func getGroups(faculty: FacultiesEntity, department: DepartmentsEntity, course: String, cache: CachePolicy = .CachedElseLoad, completionHandler: GroupsCompletionHandlet) {

        let query = GroupsQuery(faculty: faculty, department: department, course: course)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
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

    var queryInfo: GroupsServiceQueryInfo {
        return .WithParams(faculty: faculty, department: department, course: course)
    }

    var path: String = "/getGroups"

    var method: NetworkServiceMethod = .GET

    var parameters: [String: AnyObject]? {

        return ["facultyId": faculty.id,
            "departmentId": department.id,
            "course": course]
    }

    var predicate: NSPredicate? {
        return NSPredicate(format: "(faculty == %@) && (department == %@) && (course == %@) && (hidden == false)", faculty, department, course)
    }

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "title", ascending: true)]

}

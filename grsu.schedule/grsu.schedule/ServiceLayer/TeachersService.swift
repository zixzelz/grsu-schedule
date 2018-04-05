//
//  TeachersService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/2/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum TeachersServiceQueryInfo: QueryInfoType {
    case teacher(teacherId: String)
    case `default`
}

typealias TeacherCompletionHandlet = (ServiceResult<TeacherInfoEntity, ServiceError>) -> Void
typealias TeachersCompletionHandlet = (ServiceResult<[TeacherInfoEntity], ServiceError>) -> Void

class TeachersService {

    let localService: LocalService<TeacherInfoEntity>
    let networkService: NetworkService<TeacherInfoEntity>

    init() {

        localService = LocalService()
        networkService = NetworkService(localService: localService)
    }

    func getTeacher(_ teacherId: String, cache: CachePolicy = .cachedElseLoad, completionHandler: @escaping TeacherCompletionHandlet) {

        let queryInfo: TeachersServiceQueryInfo = .teacher(teacherId: teacherId)
        let query = TeachersQuery(queryInfo: queryInfo)
        networkService.fetchDataItem(query, cache: cache, completionHandler: completionHandler)
    }

    func getTeachers(_ cache: CachePolicy = .cachedElseLoad, completionHandler: @escaping TeachersCompletionHandlet) {

        let query = TeachersQuery(queryInfo: .default)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
    }

}

class TeachersQuery: NetworkServiceQueryType {

    let queryInfo: TeachersServiceQueryInfo

    init(queryInfo: TeachersServiceQueryInfo) {
        self.queryInfo = queryInfo
    }

    var path: String = UrlHost + "/getTeachers"

    var method: NetworkServiceMethod = .GET

    var parameters: [String: Any]? {

        switch queryInfo {
        case .teacher(let teacherId):
            return [
                "teacherId": teacherId,
                "extended": "true",
                Parametres.lang.rawValue: Locale.preferredLocale
            ]
        default:
            return [
                Parametres.lang.rawValue: Locale.preferredLocale
            ]
        }
    }

    var predicate: NSPredicate? {
        switch queryInfo {
        case .teacher(let teacherId):
            return NSPredicate(format: "(id == %@)", teacherId)
        default:
            return nil
        }
    }

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "title", ascending: true)]

    static var cacheTimeInterval: TimeInterval { return Constants.teachersCacheTimeInterval }

}

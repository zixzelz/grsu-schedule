//
//  TeachersService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/2/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ServiceLayerSDK
import ReactiveSwift

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
        localService = LocalService(contextProvider: CoreDataHelper.contextProvider())
        networkService = NetworkService(localService: localService)
    }

    func getTeacher(_ teacherId: String, cache: CachePolicy = .cachedElseLoad) -> SignalProducer<TeacherInfoEntity, ServiceError> {
        let queryInfo: TeachersServiceQueryInfo = .teacher(teacherId: teacherId)
        let query = TeachersQuery(queryInfo: queryInfo)
        return networkService.fetchDataItems(query, cache: cache)
            .flatMap(.latest) { $0.items(in: CoreDataHelper.managedObjectContext) }
            .flatMap(.latest) { (items) -> SignalProducer<TeacherInfoEntity, ServiceError> in
                guard let item = items.first else {
                    return SignalProducer(error: .wrongResponseFormat)
                }
                return SignalProducer(value: item)
        }
    }

    func getTeachers(_ cache: CachePolicy = .cachedElseLoad) -> SignalProducer<[TeacherInfoEntity], ServiceError> {
        let query = TeachersQuery(queryInfo: .default)
        return networkService
            .fetchDataItems(query, cache: cache)
            .flatMap(.latest) { $0.items(in: CoreDataHelper.managedObjectContext) }
    }

}

class TeachersQuery: NetworkServiceQueryType {

    var identifier: String {
        return filterIdentifier
    }

    let queryInfo: TeachersServiceQueryInfo

    init(queryInfo: TeachersServiceQueryInfo) {
        self.queryInfo = queryInfo
    }

    var path: String = UrlHost + "/getTeachers"

    var method: NetworkServiceMethod = .GET

    func parameters(range: NSRange?) -> [URLQueryItem]? {
        switch queryInfo {
        case .teacher(let teacherId):
            return [
                URLQueryItem(name: "teacherId", value: teacherId),
                URLQueryItem(name: "extended", value: "true"),
                URLQueryItem(name: Parametres.lang.rawValue, value: Locale.preferredLocale),
            ]
        default:
            return [
                URLQueryItem(name: Parametres.lang.rawValue, value: Locale.preferredLocale)
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

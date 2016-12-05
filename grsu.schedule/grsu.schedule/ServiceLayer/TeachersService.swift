//
//  TeachersService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/2/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum TeachersServiceQueryInfo: QueryInfoType {
    case Teacher(teacherId: String)
    case Default
}

typealias TeacherCompletionHandlet = ServiceResult<TeacherInfoEntity, ServiceError> -> Void
typealias TeachersCompletionHandlet = ServiceResult<[TeacherInfoEntity], ServiceError> -> Void

class TeachersService {

    let localService: LocalService<TeacherInfoEntity>
    let networkService: NetworkService<TeacherInfoEntity>
    
    init() {
        
        localService = LocalService()
        networkService = NetworkService(localService: localService)
    }
    
    func getTeacher(teacherId: String, cache: CachePolicy = .CachedElseLoad, completionHandler: TeacherCompletionHandlet) {
        
        let queryInfo: TeachersServiceQueryInfo = .Teacher(teacherId: teacherId)
        let query = TeachersQuery(queryInfo: queryInfo)
        networkService.fetchDataItem(query, cache: cache, completionHandler: completionHandler)
    }
    
    func getTeachers(cache: CachePolicy = .CachedElseLoad, completionHandler: TeachersCompletionHandlet) {
        
        let query = TeachersQuery(queryInfo: .Default)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
    }

}

class TeachersQuery: NetworkServiceQueryType {
    
    let queryInfo: TeachersServiceQueryInfo
    
    init(queryInfo: TeachersServiceQueryInfo) {
        self.queryInfo = queryInfo
    }
    
    var path: String = "/getTeachers"
    
    var method: NetworkServiceMethod = .GET
    
    var parameters: [String: AnyObject]? {
        
        switch queryInfo {
        case .Teacher(let teacherId): return ["teacherId": teacherId, "extended": "true"]
        case.Default(): return nil
        }
    }
    
    var predicate: NSPredicate? {
        switch queryInfo {
        case .Teacher(let teacherId): return NSPredicate(format: "(id == %@)", teacherId)
        case.Default(): return nil
        }
    }
    
    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "title", ascending: true)]
    
    static var cacheTimeInterval: NSTimeInterval { return TeachersCacheTimeInterval }
    
}

//
//  StudentScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/13/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ReactiveSwift
import ServiceLayerSDK

typealias StudentScheduleCompletionHandlet = (ServiceResult<[LessonScheduleEntity], ServiceError>) -> Void

class ScheduleService {

    let localService: LocalService<LessonScheduleEntity>
    let networkService: NetworkService<LessonScheduleEntity>

    init() {
        localService = LocalService(contextProvider: CoreDataHelper.contextProvider())
        networkService = NetworkService(localService: localService)
    }

    func getStudentSchedule(_ group: GroupsEntity, dateStart: Date, dateEnd: Date, cache: CachePolicy = .cachedElseLoad) -> SignalProducer<ServiceResponse<LessonScheduleEntity>, ServiceError> {
        let query = StudentScheduleQuery(group: group, dateStart: dateStart, dateEnd: dateEnd)
        return networkService.fetchDataItems(query, cache: cache)
    }

    func getMySchedule(_ studentId: String, dateStart: Date, dateEnd: Date, cache: CachePolicy = .cachedElseLoad) -> SignalProducer<ServiceResponse<LessonScheduleEntity>, ServiceError> {
        let query = MyScheduleQuery(studentId: studentId, dateStart: dateStart, dateEnd: dateEnd)
        return networkService.fetchDataItems(query, cache: cache)
    }

    func getTeacherSchedule(_ teacher: TeacherInfoEntity, dateStart: Date, dateEnd: Date, cache: CachePolicy = .cachedElseLoad) -> SignalProducer<ServiceResponse<LessonScheduleEntity>, ServiceError> {
        let query = TeacherScheduleQuery(teacher: teacher, dateStart: dateStart, dateEnd: dateEnd)
        return networkService.fetchDataItems(query, cache: cache)
    }

    func cleanCache() -> SignalProducer<Void, ServiceError> {
        var predicate: NSPredicate {
            let dayTimeInterval: TimeInterval = 60 * 60 * 24 * 10
            let dateEnd = Date(timeIntervalSinceNow: -dayTimeInterval)
            return NSPredicate(format: "(\(#keyPath(LessonScheduleEntity.date)) <= %@)", dateEnd as CVarArg)
        }

        return localService.cleanCache(predicate)
    }
}

class MyScheduleQuery: NetworkServiceQueryType {
    //http://api.grsu.by/1.x/app1/getGroupSchedule?studentId=130569

    let studentId: String
    let dateStart: Date
    let dateEnd: Date

    init(studentId: String, dateStart: Date, dateEnd: Date) {
        self.studentId = studentId
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }

    var identifier: String {
        return filterIdentifier
    }

    var queryInfo: ScheduleQueryInfo {
        return .my(studentId: studentId)
    }

    var predicate: NSPredicate? {
        return NSPredicate(format: "(\(#keyPath(LessonScheduleEntity.isTeacherSchedule)) == NO) && (\(#keyPath(LessonScheduleEntity.userId)) == %@) && (\(#keyPath(LessonScheduleEntity.date)) >= %@) && (\(#keyPath(LessonScheduleEntity.date)) <= %@)", studentId, dateStart as CVarArg, dateEnd as CVarArg)
    }

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "\(#keyPath(LessonScheduleEntity.startTime))", ascending: true)]

    // MARK - NetworkServiceQueryType

    var path: String = UrlHost + "/getGroupSchedule"

    var method: NetworkServiceMethod = .GET

    func parameters(range: NSRange?) -> [String: String]? {
        return ["studentId": studentId,
            "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
            "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2),
            Parametres.lang.rawValue: Locale.preferredLocale
        ]
    }

}

class StudentScheduleQuery: NetworkServiceQueryType {

    let group: GroupsEntity
    let dateStart: Date
    let dateEnd: Date

    init(group: GroupsEntity, dateStart: Date, dateEnd: Date) {
        self.group = group
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }

    var identifier: String {
        return filterIdentifier
    }

    var queryInfo: ScheduleQueryInfo {
        return .student(group: group)
    }

    var predicate: NSPredicate? {
        return NSPredicate(format: "(\(#keyPath(LessonScheduleEntity.isTeacherSchedule)) == NO) && (\(#keyPath(LessonScheduleEntity.userId)) == NIL) && (ANY \(#keyPath(LessonScheduleEntity.groups)) == %@) && (\(#keyPath(LessonScheduleEntity.date)) >= %@) && (\(#keyPath(LessonScheduleEntity.date)) <= %@)", group, dateStart as CVarArg, dateEnd as CVarArg)
    }

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "startTime", ascending: true)]

    // MARK - NetworkServiceQueryType

    var path: String = UrlHost + "/getGroupSchedule"

    var method: NetworkServiceMethod = .GET

    func parameters(range: NSRange?) -> [String: String]? {
        return ["groupId": group.id,
            "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
            "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2),
            Parametres.lang.rawValue: Locale.preferredLocale
        ]
    }

}

class TeacherScheduleQuery: NetworkServiceQueryType {

    let teacher: TeacherInfoEntity
    let dateStart: Date
    let dateEnd: Date

    init(teacher: TeacherInfoEntity, dateStart: Date, dateEnd: Date) {
        self.teacher = teacher
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }

    var identifier: String {
        return filterIdentifier
    }

    var queryInfo: ScheduleQueryInfo {
        return .teacher(teacher: teacher)
    }

    var predicate: NSPredicate? {
        return NSPredicate(format: "(\(#keyPath(LessonScheduleEntity.isTeacherSchedule)) == YES) && (ANY \(#keyPath(LessonScheduleEntity.teacher)) == %@) && (\(#keyPath(LessonScheduleEntity.date)) >= %@) && (\(#keyPath(LessonScheduleEntity.date)) <= %@)", teacher, dateStart as CVarArg, dateEnd as CVarArg)
    }

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "\(#keyPath(LessonScheduleEntity.date))", ascending: true), NSSortDescriptor(key: "\(#keyPath(LessonScheduleEntity.startTime))", ascending: true)]

    // MARK - NetworkServiceQueryType

    var path: String = UrlHost + "/getTeacherSchedule"

    var method: NetworkServiceMethod = .GET

    func parameters(range: NSRange?) -> [String: String]? {
        return ["teacherId": teacher.id,
            "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
            "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2),
            Parametres.lang.rawValue: Locale.preferredLocale
        ]
    }

}

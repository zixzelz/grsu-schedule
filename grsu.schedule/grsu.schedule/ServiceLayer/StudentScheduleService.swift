//
//  StudentScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/13/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

typealias StudentScheduleCompletionHandlet = (ServiceResult<[LessonScheduleEntity], ServiceError>) -> Void

class ScheduleService {

    let localService: LocalService<LessonScheduleEntity>
    let networkService: NetworkService<LessonScheduleEntity>

    init() {

        localService = LocalService()
        networkService = NetworkService(localService: localService)
    }

    func getStudentSchedule(_ group: GroupsEntity, dateStart: Date, dateEnd: Date, cache: CachePolicy = .cachedElseLoad, completionHandler: @escaping StudentScheduleCompletionHandlet) {

        let query = StudentScheduleQuery(group: group, dateStart: dateStart, dateEnd: dateEnd)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
    }

    func getMySchedule(_ studentId: String, dateStart: Date, dateEnd: Date, cache: CachePolicy = .cachedElseLoad, completionHandler: @escaping StudentScheduleCompletionHandlet) {

        let query = MyScheduleQuery(studentId: studentId, dateStart: dateStart, dateEnd: dateEnd)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
    }

    func getTeacherSchedule(_ teacher: TeacherInfoEntity, dateStart: Date, dateEnd: Date, cache: CachePolicy = .cachedElseLoad, completionHandler: @escaping StudentScheduleCompletionHandlet) {

        let query = TeacherScheduleQuery(teacher: teacher, dateStart: dateStart, dateEnd: dateEnd)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
    }

    func cleanCache(_ completionHandler: (() -> ())? = nil) {

        let query = CleanScheduleQuery()

        localService.cleanCache(query) { (result) in
            if case let .failure(error) = result {
                assertionFailure("cleanCache error: \(error)")
            }
            completionHandler?()
        }
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

    var parameters: [String: Any]? {

        return ["studentId": studentId,
            "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
            "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2),
            Parametres.lang.rawValue: Locale.currenLocale
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

    var parameters: [String: Any]? {

        return ["groupId": group.id,
            "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
            "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2),
            Parametres.lang.rawValue: Locale.currenLocale
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

    var parameters: [String: Any]? {

        return ["teacherId": teacher.id,
            "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
            "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2),
            Parametres.lang.rawValue: Locale.currenLocale
        ]
    }

}

class CleanScheduleQuery: LocalServiceQueryType {

    var predicate: NSPredicate? {

        let monthTimeInterval: TimeInterval = 60 * 60 * 24 * 7
        let dateEnd = Date(timeIntervalSinceNow: -monthTimeInterval)
        return NSPredicate(format: "(\(#keyPath(LessonScheduleEntity.date)) <= %@)", dateEnd as CVarArg)
    }

    var queryInfo: ScheduleQueryInfo {
        return .my(studentId: "")
    }

    var sortBy: [NSSortDescriptor]? = nil
}

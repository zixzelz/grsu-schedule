//
//  StudentScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/13/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

typealias StudentScheduleCompletionHandlet = ServiceResult<[LessonScheduleEntity], ServiceError> -> Void

class ScheduleService {

    let localService: LocalService<LessonScheduleEntity>
    let networkService: NetworkService<LessonScheduleEntity>

    init() {

        localService = LocalService()
        networkService = NetworkService(localService: localService)
    }

    func getStudentSchedule(group: GroupsEntity, dateStart: NSDate, dateEnd: NSDate, cache: CachePolicy = .CachedElseLoad, completionHandler: StudentScheduleCompletionHandlet) {

        let query = StudentScheduleQuery(group: group, dateStart: dateStart, dateEnd: dateEnd)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
    }
    
    func getMySchedule(studentId: String, dateStart: NSDate, dateEnd: NSDate, cache: CachePolicy = .CachedElseLoad, completionHandler: StudentScheduleCompletionHandlet) {
        
        let query = MyScheduleQuery(studentId: studentId, dateStart: dateStart, dateEnd: dateEnd)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
    }

    func getTeacherSchedule(teacher: TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, cache: CachePolicy = .CachedElseLoad, completionHandler: StudentScheduleCompletionHandlet) {

        let query = TeacherScheduleQuery(teacher: teacher, dateStart: dateStart, dateEnd: dateEnd)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
    }
}

class MyScheduleQuery: NetworkServiceQueryType {
    //http://api.grsu.by/1.x/app1/getGroupSchedule?studentId=130569
    
    let studentId: String
    let dateStart: NSDate
    let dateEnd: NSDate
    
    init(studentId: String, dateStart: NSDate, dateEnd: NSDate) {
        self.studentId = studentId
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }
    
    var queryInfo: ScheduleQueryInfo {
        return .My(studentId: studentId)
    }
    
    var predicate: NSPredicate? {
        return NSPredicate(format: "(isTeacherSchedule == NO) && (ANY groups == %@) && (date >= %@) && (date <= %@)", studentId, dateStart, dateEnd)
    }
    
    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "startTime", ascending: true)]
    
    // MARK - NetworkServiceQueryType
    
    var path: String = "/getGroupSchedule"
    
    var method: NetworkServiceMethod = .GET
    
    var parameters: [String: AnyObject]? {
        
        return ["studentId": studentId,
                "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
                "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2)]
    }
    
}

class StudentScheduleQuery: NetworkServiceQueryType {

    let group: GroupsEntity
    let dateStart: NSDate
    let dateEnd: NSDate

    init(group: GroupsEntity, dateStart: NSDate, dateEnd: NSDate) {
        self.group = group
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }

    var queryInfo: ScheduleQueryInfo {
        return .Student(group: group)
    }

    var predicate: NSPredicate? {
        return NSPredicate(format: "(isTeacherSchedule == NO) && (ANY groups == %@) && (date >= %@) && (date <= %@)", group, dateStart, dateEnd)
    }

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "startTime", ascending: true)]

    // MARK - NetworkServiceQueryType

    var path: String = "/getGroupSchedule"

    var method: NetworkServiceMethod = .GET

    var parameters: [String: AnyObject]? {

        return ["groupId": group.id,
            "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
            "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2)]
    }

}

class TeacherScheduleQuery: NetworkServiceQueryType {

    let teacher: TeacherInfoEntity
    let dateStart: NSDate
    let dateEnd: NSDate

    init(teacher: TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate) {
        self.teacher = teacher
        self.dateStart = dateStart
        self.dateEnd = dateEnd
    }

    var queryInfo: ScheduleQueryInfo {
        return .Teacher(teacher: teacher)
    }

    var predicate: NSPredicate? {
        return NSPredicate(format: "(isTeacherSchedule == YES) && (ANY teacher == %@) && (date >= %@) && (date <= %@)", teacher, dateStart, dateEnd)
    }

    var sortBy: [NSSortDescriptor]? = [NSSortDescriptor(key: "date", ascending: true), NSSortDescriptor(key: "startTime", ascending: true)]

    // MARK - NetworkServiceQueryType

    var path: String = "/getTeacherSchedule"

    var method: NetworkServiceMethod = .GET

    var parameters: [String: AnyObject]? {

        return ["teacherId": teacher.id,
            "dateStart": DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2),
            "dateEnd": DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2)]
    }

}

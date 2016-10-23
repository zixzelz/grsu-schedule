//
//  StudentScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 9/13/16.
//  Copyright © 2016 Ruslan Maslouski. All rights reserved.
//

import UIKit

enum StudentScheduleQueryInfo: QueryInfoType {
    case Default(group: GroupsEntity)
}

typealias StudentScheduleCompletionHandlet = ServiceResult<[LessonScheduleEntity], ServiceError> -> Void

class StudentScheduleService {

    let localService: LocalService<LessonScheduleEntity>
    let networkService: NetworkService<LessonScheduleEntity>

    init() {

        localService = LocalService()
        networkService = NetworkService(localService: localService)
    }

    func getSchedule(group: GroupsEntity, dateStart: NSDate, dateEnd: NSDate, cache: CachePolicy = .CachedElseLoad, completionHandler: StudentScheduleCompletionHandlet) {

        let query = StudentScheduleQuery(group: group, dateStart: dateStart, dateEnd: dateEnd)
        networkService.fetchData(query, cache: cache, completionHandler: completionHandler)
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

    var queryInfo: StudentScheduleQueryInfo {
        return .Default(group: group)
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
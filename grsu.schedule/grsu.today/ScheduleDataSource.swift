//
//  ScheduleDataSource.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 07/11/2019.
//  Copyright © 2019 Ruslan Maslouski. All rights reserved.
//

import UIKit
import ServiceLayerSDK
import ReactiveSwift

enum ScheduleDataSource {
    case student(id: String, beginDate: Date, endDate: Date)
    case group(group: GroupsEntity, beginDate: Date, endDate: Date)
    case teacher(teacher: TeacherInfoEntity, beginDate: Date, endDate: Date)
}

extension ScheduleDataSource {
    func fetchData(cache: CachePolicy) -> SignalProducer<[LessonScheduleEntity], ServiceError> {
        switch self {
        case .group(let group, let beginDate, let endDate):
            return ScheduleService()
                .getStudentSchedule(group, dateStart: beginDate, dateEnd: endDate, cache: cache)
                .flatMap(.latest) { $0.items(in: CoreDataHelper.managedObjectContext) }
        case .student(let id, let beginDate, let endDate):
            return ScheduleService()
                .getMySchedule(id, dateStart: beginDate, dateEnd: endDate, cache: cache)
                .flatMap(.latest) { $0.items(in: CoreDataHelper.managedObjectContext) }
        case .teacher(let teacher, let beginDate, let endDate):
            return ScheduleService()
                .getTeacherSchedule(teacher, dateStart: beginDate, dateEnd: endDate, cache: cache)
                .flatMap(.latest) { $0.items(in: CoreDataHelper.managedObjectContext) }
        }
    }
}

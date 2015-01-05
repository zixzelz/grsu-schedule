//
//  LessonScheduleEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(LessonScheduleEntity)
class LessonScheduleEntity: NSManagedObject {

    @NSManaged var address: String
    @NSManaged var room: NSNumber
    @NSManaged var startTime: NSNumber
    @NSManaged var stopTime: NSNumber
    @NSManaged var studyName: String
    @NSManaged var subgroupTitle: String?
    @NSManaged var type: String
    @NSManaged var studentDaySchedule: DayScheduleEntity
    @NSManaged var teacher: TeacherInfoEntity

}

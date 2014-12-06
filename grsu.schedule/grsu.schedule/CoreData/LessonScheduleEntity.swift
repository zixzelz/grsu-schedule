//
//  LessonScheduleEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/5/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(LessonScheduleEntity)
class LessonScheduleEntity: NSManagedObject {

    @NSManaged var type: String
    @NSManaged var address: String
    @NSManaged var room: NSNumber
    @NSManaged var startTime: NSNumber
    @NSManaged var stopTime: NSNumber
    @NSManaged var studyName: String
    @NSManaged var studentDaySchedule: StudentDayScheduleEntity
    @NSManaged var teacher: TeacherInfoEntity

}

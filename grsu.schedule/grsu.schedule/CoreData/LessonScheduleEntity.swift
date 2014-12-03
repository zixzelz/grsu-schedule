//
//  LessonScheduleEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/29/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(LessonScheduleEntity)
class LessonScheduleEntity: NSManagedObject {

    @NSManaged var groupTitle: String
    @NSManaged var location: String
    @NSManaged var room: NSNumber
    @NSManaged var startTime: NSNumber
    @NSManaged var stopTime: NSNumber
    @NSManaged var studyName: String
    @NSManaged var teacher: String
    @NSManaged var studentDaySchedule: StudentDayScheduleEntity

}

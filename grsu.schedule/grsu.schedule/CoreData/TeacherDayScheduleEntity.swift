//
//  TeacherDayScheduleEntity.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import Foundation
import CoreData

@objc(TeacherDayScheduleEntity)
class TeacherDayScheduleEntity: DayScheduleEntity {

    @NSManaged var teacher: TeacherInfoEntity

}

//
//  StudentDaySchedule.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/23/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class DaySchedule: NSObject {
    
    var date : Date
    var lessons : [LessonScheduleEntity] = []

    init(date : Date) {
        self.date = date
    }

}

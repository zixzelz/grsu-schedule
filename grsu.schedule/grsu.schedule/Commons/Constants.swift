//
//  Constants.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/18/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation

enum ScheduleOption : String {
    case Departmen = "DefaultDepartmentCell"
    case Faculty = "DefaultFacultyCell"
    case Group = "DefaultGroupCell"
    case Course = "DefaultCourseCell"
    case Week = "DefaultWeekCell"
}

typealias GSItem = (id: String, value: String)
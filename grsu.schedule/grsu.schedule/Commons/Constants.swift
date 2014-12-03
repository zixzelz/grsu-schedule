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

let DepartmentsCacheTimeInterval : NSTimeInterval = 60 * 60 * 24
let FacultiesCacheTimeInterval : NSTimeInterval = 60 * 60 * 24
let GroupsCacheTimeInterval : NSTimeInterval = 60 * 60 * 24

let DepartmentsEntityName = "DepartmentsEntity"
let FacultiesEntityName =  "FacultiesEntity"
let GroupsEntityName = "GroupsEntity"
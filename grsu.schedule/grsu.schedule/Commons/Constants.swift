//
//  Constants.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/18/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation


let UrlHost = "http://api.grsu.by/1.x/app1"
let ReachabilityURL = "www.grsu.by"

enum ScheduleOption : String {
    case departmen = "DefaultDepartmentCell"
    case faculty = "DefaultFacultyCell"
    case group = "DefaultGroupCell"
    case course = "DefaultCourseCell"
    case week = "DefaultWeekCell"
}

typealias GSItem = (id: String, value: String)
typealias GSWeekItem = (startDate: Date, endDate: Date, value: String)

struct Constants {
    static let defaultCacheTimeInterval : TimeInterval = 60 * 60 * 24
    static let teachersCacheTimeInterval : TimeInterval = 60 * 60 * 24 * 7
}

let DepartmentsEntityName = "DepartmentsEntity"
let FacultiesEntityName =  "FacultiesEntity"
let GroupsEntityName = "GroupsEntity"
let LessonScheduleEntityName = "LessonScheduleEntity"
let TeacherInfoEntityName = "TeacherInfoEntity"
let FavoriteEntityName = "FavoriteEntity"

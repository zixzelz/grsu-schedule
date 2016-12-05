//
//  Constants.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/18/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import Foundation


let UrlScheme = "http"
let UrlHost = "api.grsu.by/1.x/app1"
let ReachabilityURL = "www.grsu.by"

enum ScheduleOption : String {
    case Departmen = "DefaultDepartmentCell"
    case Faculty = "DefaultFacultyCell"
    case Group = "DefaultGroupCell"
    case Course = "DefaultCourseCell"
    case Week = "DefaultWeekCell"
}

typealias GSItem = (id: String, value: String)
typealias GSWeekItem = (startDate: NSDate, endDate: NSDate, value: String)

let DefaultCacheTimeInterval : NSTimeInterval = 60 * 60 * 24
let TeachersCacheTimeInterval : NSTimeInterval = 60 * 60 * 24 * 7

let DepartmentsEntityName = "DepartmentsEntity"
let FacultiesEntityName =  "FacultiesEntity"
let GroupsEntityName = "GroupsEntity"
let LessonScheduleEntityName = "LessonScheduleEntity"
let TeacherInfoEntityName = "TeacherInfoEntity"
let FavoriteEntityName = "FavoriteEntity"

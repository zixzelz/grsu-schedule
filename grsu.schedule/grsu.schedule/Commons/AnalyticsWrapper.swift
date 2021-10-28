//
//  AnalyticsWrapper.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 28.10.21.
//  Copyright © 2021 Ruslan Maslouski. All rights reserved.
//

import Firebase
import Flurry_iOS_SDK

class AnalyticsWrapper {

    enum Event: String {
        case login
        case addFavoriteGroup
        case addFavoriteTeacher
        case removeFavoriteGroup
        case removeFavoriteTeacher
        case lessonLocationMap
        case routeWithYandexMaps
        case openScheduleForGroup
        case openScheduleForTeacher
        case openMySchedule
        case listOfTeachers
        case teacherInfo
    }

    static func logEvent(_ event: Event, parameters: [String: Any]? = nil) {
        Analytics.logEvent(event.name, parameters: parameters)
        Flurry.logEvent(event.name, withParameters: parameters)
    }

}

extension AnalyticsWrapper.Event {

    var name: String {
        switch self {
        case .login:
            return AnalyticsEventLogin
        case .addFavoriteGroup:
            return "add_favorite_group"
        case .addFavoriteTeacher:
            return "add_favorite_teacher"
        case .removeFavoriteGroup:
            return "remove_favorite_group"
        case .removeFavoriteTeacher:
            return "remove_favorite_teacher"
        case .lessonLocationMap:
            return "Lesson_Location_Map"
        case .routeWithYandexMaps:
            return "route_with_yandex_maps"
        case .openScheduleForGroup:
            return "open_schedule_for_group"
        case .openScheduleForTeacher:
            return "open_schedule_for_teacher"
        case .openMySchedule:
            return "open_My_schedule"
        case .listOfTeachers:
            return "List_Of_Teachers"
        case .teacherInfo:
            return "Teacher_Info"
        }
    }

}

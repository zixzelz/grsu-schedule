//
//  GetStudentScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/23/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GetStudentScheduleService: BaseDataService {
   
    class func getSchedule(groupId : String, week: String, completionHandler: ((Array<StudentDaySchedule>?, NSError?) -> Void)!) {
        
        let path = "/getGroupSchedule"
        
        let queryItems = [
            NSURLQueryItem(name: "groupId", value: groupId),
            NSURLQueryItem(name: "dateStart", value: week),
            NSURLQueryItem(name: "dateEnd", value: week)
        ]
        
        resumeRequest(path, queryItems: queryItems, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            let lesson1 = LessonSchedule()
            lesson1.groupTitle = "11"
            lesson1.location = "22"
            lesson1.room = 203
            lesson1.studyName = "gs gsfd g"
            lesson1.startTime = 500
            lesson1.stopTime = 600
            
            let day1 = StudentDaySchedule()
            day1.date = NSDate()
            day1.lessons = [lesson1, lesson1]

            let day2 = StudentDaySchedule()
            day2.date = NSDate()
            day2.lessons = [lesson1, lesson1]

            completionHandler([day1, day2], nil)
        })
    }

}

//
//  GetTeacherScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 1/5/15.
//  Copyright (c) 2015 Ruslan Maslouski. All rights reserved.
//

import UIKit
import CoreData

class GetTeacherScheduleService: BaseDataService {

    class func featchSchedule(teacher : TeacherInfoEntity, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<StudentDaySchedule>?, NSError?) -> Void)!) {
        
        let path = "/getTeacherScheduleFake"
        
        let queryItems = [
            NSURLQueryItem(name: "groupId", value: groupId),
            NSURLQueryItem(name: "dateStart", value: DateUtils.formatDate(dateStart, withFormat: DateFormatDayMonthYear2)),
            NSURLQueryItem(name: "dateEnd", value: DateUtils.formatDate(dateEnd, withFormat: DateFormatDayMonthYear2))
        ]
        
        resumeRequest(path, queryItems: queryItems, completionHandler: { (result: NSDictionary?, error: NSError?) -> Void in
            
            var res : [StudentDaySchedule] = Array()
            if let days = result?["days"] as? [NSDictionary] {
                
                for day in days {
                    
                    var scheduLelessons : [LessonSchedule] = Array()
                    if let lessons = day["lessons"] as? [NSDictionary] {
                        
                        for lesson in lessons {
                            let room = lesson["room"] as String?
                            let timeStart = lesson["timeStart"] as String
                            let timeEnd = lesson["timeEnd"] as String
                            let teacher = lesson["teacher"] as NSDictionary
                            
                            let teacherInfo = BaseTeacherInfo()
                            teacherInfo.id = teacher["id"] as? String
                            teacherInfo.fullname = teacher["fullname"] as? String
                            teacherInfo.post = teacher["post"] as? String
                            
                            let subGroup = lesson["subgroup"] as NSDictionary?
                            
                            let scheduLelesson = LessonSchedule()
                            scheduLelesson.studyName = lesson["title"] as? String
                            scheduLelesson.room = room != nil ? room!.toInt() : 0
                            scheduLelesson.address = lesson["address"] as? String
                            scheduLelesson.type = lesson["type"] as? String
                            scheduLelesson.startTime = self.timeIntervalWithTimeText(timeStart)
                            scheduLelesson.stopTime = self.timeIntervalWithTimeText(timeEnd)
                            scheduLelesson.teacher = teacherInfo
                            
                            if let subGroup = subGroup {
                                scheduLelesson.subgroupTitle = subGroup["title"] as? String
                            }
                            
                            scheduLelessons.append(scheduLelesson)
                        }
                    }
                    
                    let strDate = day["date"] as String
                    
                    let daySchedule = StudentDaySchedule()
                    daySchedule.date = DateUtils.dateFromString(strDate, format: DateFormatKeyDateInDefaultFormat)
                    daySchedule.lessons = scheduLelessons
                    
                    res.append(daySchedule)
                }
                
            }
            
            completionHandler(res, error)
        })
    }

    
}

//
//  GetStudentScheduleService.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/23/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class GetStudentScheduleService: BaseDataService {
   
    class func getSchedule(groupId : String, dateStart: NSDate, dateEnd: NSDate, completionHandler: ((Array<StudentDaySchedule>?, NSError?) -> Void)!) {
        
        let path = "/getGroupSchedule"
        
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
                            
                            let scheduLelesson = LessonSchedule()
                            scheduLelesson.studyName = lesson["title"] as? String
                            scheduLelesson.room = room != nil ? room!.toInt() : 0
                            scheduLelesson.address = lesson["address"] as? String
                            scheduLelesson.type = lesson["type"] as? String
                            scheduLelesson.startTime = self.timeIntervalWithTimeText(timeStart)
                            scheduLelesson.stopTime = self.timeIntervalWithTimeText(timeEnd)
                            
                            scheduLelessons.append(scheduLelesson)
                        }
                    }
                    
                    let strDate = day["date"] as String
                    let arrSchedules = day["date"] as [NSDictionary]
                    
                    let daySchedule = StudentDaySchedule()
                    daySchedule.date = DateUtils.dateFromString(strDate, format: DateFormatKeyDateInDefaultFormat)
                    daySchedule.lessons = scheduLelessons
                    
                    res.append(daySchedule)
                }
                
            }
            
            completionHandler(res, error)
        })
    }

    // pragma mark - Utils
    
    class func timeIntervalWithTimeText(time: String) -> Int {
        let arr = time.componentsSeparatedByString(":")
        let h : Int = arr[0].toInt()!
        let m : Int = arr[1].toInt()!
        
        return h * 60 + m
    }

    
}

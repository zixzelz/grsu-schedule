//
//  WeekManager.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/8/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class DateManager: NSObject {
 
    class func scheduleWeeks() -> [GSWeekItem] {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        
        var startOfTheWeek : NSDate?
        var endOfWeek : NSDate?
        var interval: NSTimeInterval = 0
        
        calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, startDate: &startOfTheWeek, interval: &interval, forDate: date)
        
        var items  = Array<GSWeekItem>()
        for (var i = 0; i < 4; i++) {
            let endOfWeek = startOfTheWeek?.dateByAddingTimeInterval(interval-1)
            
            let dateStartString = formatterDate.stringFromDate(startOfTheWeek!)
            let dateEndString = formatterDate.stringFromDate(endOfWeek!)
            
            let value = dateStartString + " - " + dateEndString
            let gsItem = GSWeekItem(startOfTheWeek!, endOfWeek!, value)
            
            items.append(gsItem)
            startOfTheWeek = startOfTheWeek?.dateByAddingTimeInterval(interval)
        }
        return items
    }

    class func daysBetweenDate(fromDateTime: NSDate, toDateTime: NSDate) -> Int {
        var fromDate: NSDate?
        var toDate: NSDate?
    
        let calendar = NSCalendar.currentCalendar();
    
        calendar.rangeOfUnit(.CalendarUnitDay, startDate: &fromDate, interval: nil, forDate: fromDateTime)
        calendar.rangeOfUnit(.CalendarUnitDay, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.CalendarUnitDay, fromDate: fromDate!, toDate: toDate!, options: nil)
        
        return difference.day;
    }
    
    class func timeIntervalWithTimeText(time: String) -> Int {
        let arr = time.componentsSeparatedByString(":")
        let h : Int = arr[0].toInt()!
        let m : Int = arr[1].toInt()!
        
        return h * 60 + m
    }

}

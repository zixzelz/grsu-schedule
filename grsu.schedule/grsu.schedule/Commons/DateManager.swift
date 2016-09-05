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
//        var endOfWeek : NSDate?
        var interval: NSTimeInterval = 0
        
        //TODO: NSCalendarUnit .WeekCalendarUnit
        calendar.rangeOfUnit(.WeekOfMonth, startDate: &startOfTheWeek, interval: &interval, forDate: date)
        
        var items  = [GSWeekItem]()
        for  _ in 0 ..< 4 {
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
    
        calendar.rangeOfUnit(.Day, startDate: &fromDate, interval: nil, forDate: fromDateTime)
        calendar.rangeOfUnit(.Day, startDate: &toDate, interval: nil, forDate: toDateTime)
        
        let difference = calendar.components(.Day, fromDate: fromDate!, toDate: toDate!, options: [])
        
        return difference.day;
    }
    
    class func timeIntervalWithTimeText(time: String) -> Int {
        
        let arr = time.componentsSeparatedByString(":")
        let h : Int = Int(arr[0])!
        let m : Int = Int(arr[1])!
        
        return h * 60 + m
    }

}

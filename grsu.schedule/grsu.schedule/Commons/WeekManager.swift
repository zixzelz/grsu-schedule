//
//  WeekManager.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 12/8/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

class WeekManager: NSObject {
 
    class func scheduleWeeks() -> Array<GSWeekItem>! {
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

    
}

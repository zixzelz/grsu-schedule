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

        let date = Date()
        let formatterDate = DateFormatter() // todo: create cache of formatters
        formatterDate.dateStyle = .short

        var startOfTheWeek: Date = date.dateFromBeginningOfWeek()
        let interval: TimeInterval = 604800 // 1 weak

        var items = [GSWeekItem]()
        for _ in 0 ..< 4 {
            let endOfWeek = startOfTheWeek.addingTimeInterval(interval - 1)

            let dateStartString = formatterDate.string(from: startOfTheWeek)
            let dateEndString = formatterDate.string(from: endOfWeek)

            let value = dateStartString + " - " + dateEndString
            let gsItem = GSWeekItem(startOfTheWeek, endOfWeek, value)

            items.append(gsItem)
            startOfTheWeek = startOfTheWeek.addingTimeInterval(interval)
        }
        return items
    }

    class func daysBetweenDate(_ fromDateTime: Date, toDateTime: Date) -> Int {
        var fromDate = Date()
        var toDate = Date()

        let calendar = Calendar.current
        var interval: TimeInterval = 0

        _ = calendar.dateInterval(of: .day, start: &fromDate, interval: &interval, for: fromDateTime)
        _ = calendar.dateInterval(of: .day, start: &toDate, interval: &interval, for: toDateTime)

        let difference = (calendar as NSCalendar).components(.day, from: fromDate, to: toDate, options: [])

        return difference.day!
    }

    class func timeIntervalWithTimeText(_ time: String) -> Int? {

        let arr = time.components(separatedBy: ":")
        guard
            let hour = arr.first, let h = Int(hour),
            let minutes = arr.last, let m = Int(minutes) else {
                return nil
        }

        return h * 60 + m
    }

}

extension Date {
    func dateFromBeginningOfWeek() -> Date {
        let calendar = Calendar.current
        var startOfTheWeek: Date = Date()
        var interval: TimeInterval = 0
        _ = calendar.dateInterval(of: .weekOfMonth, start: &startOfTheWeek, interval: &interval, for: self)

        return startOfTheWeek
    }

    func startEndOfWeak() -> (Date, Date) {
        let calendar = Calendar.current
        var startOfTheWeek: Date = Date()
        var interval: TimeInterval = 0
        _ = calendar.dateInterval(of: .weekOfMonth, start: &startOfTheWeek, interval: &interval, for: self)
        let endOfWeek = startOfTheWeek.addingTimeInterval(interval - 1)

        return (startOfTheWeek, endOfWeek)
    }
}

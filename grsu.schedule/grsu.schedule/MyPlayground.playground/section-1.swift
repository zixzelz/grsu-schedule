// Playground - noun: a place where people can play

import UIKit

let date = NSDate()
let calendar = NSCalendar.currentCalendar()

var startOfTheWeek : NSDate?
var endOfWeek : NSDate?
var interval: NSTimeInterval = 0

calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, startDate: &startOfTheWeek, interval: &interval, forDate: date)
endOfWeek = startOfTheWeek?.dateByAddingTimeInterval(interval-1)

startOfTheWeek
endOfWeek
interval


typealias Point = (x:String, y:String)

var points:Array<Point> = [("1","1"), ("1","2"), ("1","3"), ("1","4")]

println (points)

let arr = Array(count: 1001, repeatedValue: 50)

let n = NSDate().timeIntervalSinceReferenceDate


let v = NSDate().timeIntervalSinceReferenceDate - n

let d = NSDate().dateByAddingTimeInterval(5000)

let z: Double = 50
let x: Double = 5.2

d.timeIntervalSinceDate(NSDate()) / ( z - x)

var fromDate: NSDate?
var toDate: NSDate?

calendar.rangeOfUnit(.CalendarUnitDay, startDate: &fromDate, interval: nil, forDate: NSDate())
calendar.rangeOfUnit(.CalendarUnitDay, startDate: &toDate, interval: nil, forDate: NSDate().dateByAddingTimeInterval(500000))

let difference = calendar.components(.CalendarUnitDay, fromDate: fromDate!, toDate: toDate!, options: nil)
difference.day

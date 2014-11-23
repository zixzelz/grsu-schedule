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

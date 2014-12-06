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


var myString : String = "Swift is Swift really easy!"

let str = myString.stringByReplacingOccurrencesOfString("^Swift ", withString: "", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)


let nsRange = Range<String.Index>(start: advance(str.startIndex, 0), end: advance(str.startIndex, 1))
let z = str.stringByReplacingCharactersInRange(nsRange, withString:str.substringToIndex(advance(str.startIndex, 1)).capitalizedString)

if myString.rangeOfString("easy") != nil {
    
    println("Exists!")
    
}

var schedules : Array<Int>?

var title: String
if (schedules == nil || schedules?.count == 0) {
    title = "Нет расписания на данную неделю"
} else {
    title = "неделю"
}
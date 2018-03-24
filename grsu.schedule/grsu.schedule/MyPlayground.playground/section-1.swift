// Playground - noun: a place where people can play

import UIKit

//let date = NSDate()
//let calendar = NSCalendar.currentCalendar()
//
//var startOfTheWeek : NSDate?
//var endOfWeek : NSDate?
//var interval: NSTimeInterval = 0
//
//calendar.rangeOfUnit(NSCalendarUnit.WeekCalendarUnit, startDate: &startOfTheWeek, interval: &interval, forDate: date)
//endOfWeek = startOfTheWeek?.dateByAddingTimeInterval(interval-1)
//
//startOfTheWeek
//endOfWeek
//interval
//
//
//typealias Point = (x:String, y:String)
//
//var points:Array = [1,2,3,4,5,6]
//
//points.filter({ return $0 == 3})
//
//
//let arr = Array(count: 1001, repeatedValue: 50)
//
//let n = NSDate().timeIntervalSinceReferenceDate
//
//
//let v = NSDate().timeIntervalSinceReferenceDate - n
//
//let d = NSDate().dateByAddingTimeInterval(5000)
//
//let z: Double = 50
//let x: Double = 5.2
//
//d.timeIntervalSinceDate(NSDate()) / ( z - x)
//
//var fromDate: NSDate?
//var toDate: NSDate?
//
//calendar.rangeOfUnit(.CalendarUnitDay, startDate: &fromDate, interval: nil, forDate: NSDate())
//calendar.rangeOfUnit(.CalendarUnitDay, startDate: &toDate, interval: nil, forDate: NSDate().dateByAddingTimeInterval(500000))
//
//let difference = calendar.components(.CalendarUnitDay, fromDate: fromDate!, toDate: toDate!, options: nil)
//difference.day
//
//
//let f = CGRectMake(20, 20, 50, 50)
//
//CGRectGetMidX(f)


protocol AAA {
    
    static func ins() -> Self
    
}


extension AAA {
    
    static func ins() -> Self {
        return "" as! Self
    }
}

let text = "⭕️😇⭕️😇You can [Parental Control](PIN_PARENTAL_CONTROL_LINK) [My](PIN_PARENTAL).[123](PIN_123)."

let pattern = "\\[[^\\]]*\\]\\([^\\)]*\\)"

struct GAction<T> {
    let range: T
    let key: String
    let title: String
}
typealias Action = GAction<Range<String.Index>>
typealias NSAction = GAction<NSRange>

private func actionsFromString(_ text: String) -> [Action] {
    let text1 = text
    
    guard let dateRegex = try? NSRegularExpression(pattern: pattern, options: []) else {
        return []
    }
    
    let matches = dateRegex.matches(in: text, options: [], range: NSRange(location: 0, length: text.characters.count))
    
    var actions = [Action]()
    
    for match in matches where match.numberOfRanges > 0 {
        
        let range = match.rangeAt(0)
        print(range.location)
        
        let start = text.index(text.startIndex, offsetBy: range.location)
        let end = text.index(start, offsetBy: range.length)
        let resRange = text.index(start, offsetBy: 1) ..< text.index(end, offsetBy: -2)
        let result = text[resRange]
        print(result)
        
        let keyValue = result.components(separatedBy: "](")
        if let key = keyValue.last, let value = keyValue.first {
            let fullRange = start ..< end
            let action = Action(range: fullRange, key: key, title: value)
            actions.append(action)
        }
    }
    
    return actions
}

func replaceTextWithActions(text: String, actions: [Action]) -> (NSString, [NSAction]) {
    var newString = text
    
    var nsActions = [NSAction]()
    
    var offset = 0
    
    for action in actions {
        
        let range = text.range(action.range, offsetBy: -offset)
        
        let titleLength = action.title.characters.count
        offset += text.distance(action.range) - titleLength
        
        newString.replaceSubrange(range, with: action.title)
        
        let newRange = range.lowerBound ..< newString.index(range.lowerBound, offsetBy: titleLength)
        let nsRange = newString.nsRange(from: newRange)
        print(newString[newRange])
        
        let nsAction = NSAction(range: nsRange, key: action.key, title: action.title)
        nsActions.append(nsAction)
    }
    
    return (newString as NSString, nsActions)
}

let actions = actionsFromString(text)

let (newText, newActions) = replaceTextWithActions(text: text, actions: actions)

let cc = newText.substring(with: NSMakeRange(0, 6))
print(cc)
extension String {
    
    func distance(_ range: Range<String.Index>) -> String.IndexDistance {
        return distance(from: range.lowerBound, to: range.upperBound)
    }
    
    func range(_ range: Range<String.Index>, offsetBy n: String.IndexDistance) -> Range<String.Index> {
        let start = index(range.lowerBound, offsetBy: n)
        let end = index(range.upperBound, offsetBy: n)
        return start ..< end
    }
    
    func nsRange(from range: Range<Index>) -> NSRange {
        let lower = UTF16View.Index(range.lowerBound, within: utf16)
        let upper = UTF16View.Index(range.upperBound, within: utf16)
        return NSRange(location: utf16.startIndex.distance(to: lower), length: lower.distance(to: upper))
    }
    
}

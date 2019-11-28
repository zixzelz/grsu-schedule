//
//  Formatter.swift
//  greencode-ios-native
//
//  Created by Ruslan Maslouski on 21/10/2018.
//  Copyright © 2018 Ruslan Maslouski. All rights reserved.
//

import UIKit

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()

    static let defaultDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static let dayOfWeekAndMonthAndDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "cccc, d LLLL"
        return formatter
    }()

    static let dateFormatDayMonthYear2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    var defaultDateFormatter: String {
        return Formatter.defaultDateFormatter.string(from: self)
    }
    var dayOfWeekAndMonthAndDayFormatter: String {
        return Formatter.dayOfWeekAndMonthAndDayFormatter.string(from: self)
    }
    var dateFormatDayMonthYear2: String {
        return Formatter.dateFormatDayMonthYear2.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self) // "Mar 22, 2017, 10:22 AM"
    }
    var dateFromDefaultDateFormatter: Date? {
        return Formatter.defaultDateFormatter.date(from: self)
    }
}

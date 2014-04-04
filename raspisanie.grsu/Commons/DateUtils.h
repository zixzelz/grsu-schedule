//
//  DateUtils.h
//  HelpBook
//
//  Created by Ruslan Maslouski on 8/23/13.
//  Copyright (c) 2013 HelpBook Inc. All rights reserved.
//

// TODO: adjust enum names
typedef enum {
    DateFormatTimeOnly = 0,
    DateFormatDateOnly,
    DateFormatDateWithTime,
    DateFormatNewsHeadlines,
    DateFormatShortDate,
    DateFormatShortDateWithTime,
    DateFormatDayMonthYear,
    DateFormatDayMonth,
    DateFormatOnlyTime12,
    DateFormatDayMonthShortYear,
    DateFormatEndOfToday,
    DateFormatMonthYear,
    DateFormatDate,
    DateFormatDateOrTodaysTime,
    DateFormatShortDateOnly,
    DateFormatDateWithTime12,
    DateFormatDateAndTimeInDefaultFormat,
    DateFormatDateWithTimeStoryDate,
    DateFormatDateWithTimeStoryDateWithTimeZone,
    DateFormatDesktopStyle,
    DateFormatDesktopStyleOnlyDate,
    DateFormatDesktopStyleOnlyTime,
    DateFormatFullDateAndTimeWithoutZone,
    DateFormatFullDateAndTimeWithoutZoneAndSeconds,
    DateFormatShortTimeOnly,
    DateFormatDayMonthYearWithoutSeparator,
    DateFormatDayOfWeekAndMonthAndDay
} DateFormatStyle;

@interface DateUtils : NSObject {
}
+ (NSString*)formatDate:(NSDate*)date withFormat:(DateFormatStyle)format;
+ (NSString *)stringToDate:(NSString *)str withFormat:(DateFormatStyle) format;
+ (NSString*)formatDate:(NSDate*)date withFormat:(DateFormatStyle)format timeZone:(NSString *)timeZone;
+ (NSDateFormatter *)dateFormatter:(NSString *)format formatBehavior:(NSDateFormatterBehavior)formatterBehavior withTimeZone:(NSString *)timeZone;
+ (NSDateFormatter *)dateFormatter:(NSString *)format  formatBehavior:(NSDateFormatterBehavior)formatterBehavior;
+ (NSDateFormatter *)dateFormatter:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format withDefauleLocale:(BOOL)defaultLocale;
+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format withTimeZone:(NSString *)timeZone;
+ (NSDate *)dateTimeNow;

+ (BOOL)is24HourFormat;

+ (NSDate *)dateFromISO8601String:(NSString *)string;
+ (BOOL)isToday:(NSDate *)date;

+ (NSString*)desktopFormatPatternDateTime;
+ (NSString*)desktopFormatPatternTime;
+ (NSString*)desktopFormatPatternDate;
@end

NSString *const DateFormatKeyDateAndTimeInDefaultFormat;
NSString *const DateFormatKeyDayOfWeekAndMonth;

//
//  DateUtils.h
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 8/23/13.
//  Copyright (c) 2013 Ruslan Maslouski. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: adjust enum names
typedef enum {
    DateFormatDateOnly = 0,
    DateFormatDayMonthYear2,
    DateFormatDayMonth,
    DateFormatOnlyTime12,
    DateFormatShortDateOnly,
    DateFormatDateAndTimeInDefaultFormat,
    DateFormatDesktopStyleOnlyTime,
    DateFormatForUserRequestAccepted,
    DateFormatTimeCommaAndDate,
    DateFormatShortTimeOnly,
    DateFormatDayMonthYearWithoutSeparator,
    DateFormatDayOfWeekAndMonthAndDay,
    DateFormatShortDayOfWeekAndMonthAndDay,
    DateFormatShortTimeHourOnly,
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
+ (NSDate *)dateTimeNow;

+ (BOOL)is24HourFormat;

+ (NSDate *)dateFromISO8601String:(NSString *)string;
+ (BOOL)isToday:(NSDate *)date;

+ (NSString*)desktopFormatPatternTime;
@end

NSString *const DateFormatKeyDateAndTimeInDefaultFormat;
NSString *const DateFormatKeyDayOfWeekAndMonth;
NSString *const DateFormatKeyDateInDefaultFormat;
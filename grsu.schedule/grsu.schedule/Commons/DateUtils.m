//
//  DateUtils.h
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 8/23/13.
//  Copyright (c) 2013 Ruslan Maslouski. All rights reserved.
//

#import "DateUtils.h"
#import "NSString+Expanded.h"

@implementation DateUtils

//int static EPSecondsPerYear = (60 * 60 * 24 * 365);
//int static EPSecondsPerDay = (60 * 60 * 24);

static NSMutableDictionary *dateFormats_ = nil;

+ (NSDate *)dateFromISO8601String:(NSString *)string {
    if ([NSString isNilOrEmpty:string]) {
        return nil;
    }
    
    struct tm tm;
    time_t t;
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], "%Y%m%dT%H%M%S%z", &tm);
    //    tm.tm_isdst = -1;
    //    t = mktime(&tm) + [[NSTimeZone localTimeZone] secondsFromGMT];
    t = timegm(&tm);
    return [NSDate dateWithTimeIntervalSince1970:t];
}

+ (NSMutableDictionary *)dateFormatters {
    static NSMutableDictionary *dateFormatters = nil;
    if (dateFormatters == nil) {
        dateFormatters = [NSMutableDictionary new];
    }
    return dateFormatters;
}

+(NSDateFormatter *)dateFormatter:(NSString *)format formatBehavior:(NSDateFormatterBehavior)formatterBehavior{
    return [DateUtils dateFormatter:format formatBehavior:formatterBehavior withTimeZone:nil];
}

+(NSDateFormatter *)dateFormatter:(NSString *)format formatBehavior:(NSDateFormatterBehavior)formatterBehavior withTimeZone:(NSString *)timeZone {
    return [self dateFormatter:format formatBehavior:formatterBehavior withTimeZone:timeZone withDefauleLocale:NO];
}

+(NSDateFormatter *)dateFormatter:(NSString *)format formatBehavior:(NSDateFormatterBehavior)formatterBehavior withTimeZone:(NSString *)timeZone withDefauleLocale:(BOOL)defaultLocale  {
    NSMutableString *key = [format mutableCopy];
    switch (formatterBehavior) {
        case NSDateFormatterBehavior10_4:
            [key appendString:@"_1040_"];
            break;
        case NSDateFormatterBehaviorDefault:
            [key appendString:@"_0_"];
            break;
        default:{
            [key appendString:@"_"];
            [key appendString:[NSString stringWithFormat:@"%u",formatterBehavior]];
            [key appendString:@"_"];
            break;
        }
    }
    if (timeZone != nil) {
        [key appendString:timeZone];
    }
    
    if (defaultLocale) {
        [key appendString:@"_default_"];
    }
    NSDateFormatter *dateFormatter = [[self dateFormatters ] objectForKey:key];
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:format];
        [dateFormatter setFormatterBehavior:formatterBehavior];
        if (defaultLocale) {
            NSLocale* locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
            dateFormatter.locale = locale;
        }
        if ([NSString isNilOrEmpty:timeZone]) {
            [dateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        } else {
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:timeZone]];
        }
        [[self dateFormatters] setObject:dateFormatter forKey:key];
    }
    return dateFormatter;
}

+(NSDateFormatter *)dateFormatter:(NSString *)format {
    return [self dateFormatter:format withDefauleLocale:NO];
}

+(NSDateFormatter *)dateFormatter:(NSString *)format  withDefauleLocale:(BOOL)defaultLocale  {
    return [DateUtils dateFormatter:format formatBehavior:NSDateFormatterBehaviorDefault withTimeZone:nil withDefauleLocale:defaultLocale];
}

+ (NSString *)stringToDate:(NSString *)str withFormat:(DateFormatStyle) format {
    NSDate *date = [DateUtils dateFromString:str format:@"yyyy-MM-dd HH:mm:ss ZZ"];
    NSString *result = nil;
    if (date != nil) {
        result = [DateUtils formatDate:date withFormat:format];
    }
    return result;
}

+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format {
    return [self dateFromString:strDate format:format withDefauleLocale:NO];
}

+ (NSDate *)dateFromString:(NSString *)strDate format:(NSString *)format withDefauleLocale:(BOOL)defaultLocale {
    return [[DateUtils dateFormatter:format withDefauleLocale:defaultLocale] dateFromString:strDate];
}

+ (BOOL)isToday:(NSDate *)date {
    return [[self formatDate:[NSDate date] withFormat:DateFormatDateOnly] isEqualToString:[self formatDate:date withFormat:DateFormatDateOnly]];
}

+ (NSString*)formatDate:(NSDate*)date withFormat:(DateFormatStyle) format timeZone:(NSString *)timeZone {
    // copy input date value, add device timezone
    NSString *dateFormat = nil;
    
    switch (format){
            
        case DateFormatDateOnly:
            dateFormat = [DateUtils desktopFormatPatternDate];
            break;
            
        case DateFormatDayMonthYear2:
            dateFormat = @"dd MMM, yyyy";
            break;
            
        case DateFormatDayMonth:
            dateFormat = @"dd MMM";
            break;
            
        case DateFormatOnlyTime12:
            dateFormat = @"hh:mm a";
            break;
            
        case DateFormatShortDateOnly:
            dateFormat = @"MMMM d, yyyy";
            break;
            
        case DateFormatDateAndTimeInDefaultFormat:
            dateFormat = DateFormatKeyDateAndTimeInDefaultFormat;
            break;
            
        case DateFormatForUserRequestAccepted:
            dateFormat = @"hh:mm a 'on' MMM-dd-yy";;
            break;
            
        case DateFormatTimeCommaAndDate:
            dateFormat = @"hh:mm a, MMM-dd-yyyy";;
            break;

        case DateFormatDayOfWeekAndMonthAndDay:
            dateFormat = @"cccc, d LLLL";
            break;
            
        case DateFormatShortDayOfWeekAndMonthAndDay:
            dateFormat = @"ccc, LLLL d";
            break;
            
        case DateFormatDesktopStyleOnlyTime: {
            dateFormat = [DateUtils desktopFormatPatternTime];
            break;
        }
            
        case DateFormatShortTimeOnly:
            dateFormat = @"hh:mm a";
            break;
            
        case DateFormatDayMonthYearWithoutSeparator:
            dateFormat = @"ddMMyyyy";
            break;
            
        case DateFormatShortTimeHourOnly:
            dateFormat = @"ha";
            break;
            
        default:
            dateFormat = [NSString string];
    }
    
    //Set time format as per device settings
    if ([dateFormat rangeOfString:@":mm"].length != 0) {
        if ([self is24HourFormat]) {
            dateFormat = [dateFormat stringByReplacingOccurrencesOfString:@" a" withString:@""];
            dateFormat = [dateFormat stringByReplacingOccurrencesOfString:@"a" withString:@""];
            dateFormat = [dateFormat stringByReplacingOccurrencesOfString:@"h" withString:@"H"];
        }
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChanged) name:NSCurrentLocaleDidChangeNotification object:nil];
    });
    // localize
    //dateFormat = [self dateFormatFromTemplate:dateFormat options:0 locale:[NSLocale currentLocale]];
    
    NSDateFormatter* formatter;
    if ([NSString isNilOrEmpty:timeZone]) {
        formatter = [DateUtils dateFormatter:dateFormat formatBehavior:NSDateFormatterBehavior10_4];
    } else {
        formatter = [DateUtils dateFormatter:dateFormat formatBehavior:NSDateFormatterBehavior10_4 withTimeZone:timeZone];
    }
    
    return [formatter stringFromDate:date];
}

+ (NSString*)desktopFormatPatternDate {
    NSDateFormatter* dateFormatter = [DateUtils dateFormatter:@"device2" formatBehavior:NSDateFormatterBehavior10_4];
    if ([dateFormatter timeStyle] != NSDateFormatterNoStyle || [dateFormatter dateStyle] != NSDateFormatterShortStyle) {
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    }
    return [dateFormatter dateFormat];
}

+ (NSString*)desktopFormatPatternTime {
    NSDateFormatter* dateFormatter = [DateUtils dateFormatter:@"device3" formatBehavior:NSDateFormatterBehavior10_4];
    if ([dateFormatter timeStyle] != NSDateFormatterShortStyle || [dateFormatter dateStyle] != NSDateFormatterNoStyle) {
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    }
    return [dateFormatter dateFormat];
}

+ (void)localeDidChanged {
    [dateFormats_ removeAllObjects];
}

+ (NSString *)dateFormatFromTemplate:(NSString *)tmplate options:(NSUInteger)opts locale:(NSLocale *)locale {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormats_ = [NSMutableDictionary new];
    });
    NSString* result = [dateFormats_ objectForKey:tmplate];
    if (result == nil) {
        result = [NSDateFormatter dateFormatFromTemplate:tmplate options:0 locale:[NSLocale currentLocale]];
        [dateFormats_ setObject:result forKey:tmplate];
    }
    return result;
}

+ (NSString*)formatDate:(NSDate*)date withFormat:(DateFormatStyle) format {
    if (date == nil || [date isEqual:[NSNull null]]) {
        return @"";
    }
    
    return [DateUtils formatDate:date withFormat:format timeZone:nil];
}

+ (BOOL)is24HourFormat { //TODO: find another implementation for defining time format from settings
    NSString* key = @"is24HourFormat";
    NSDateFormatter *formatter = [[self dateFormatters] objectForKey:key];
    if (formatter == nil) {
        formatter = [NSDateFormatter new];
        [formatter setDateStyle:NSDateFormatterNoStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [[self dateFormatters] setObject:formatter forKey:key];
    }
    
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24Hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    return is24Hour;
}

+ (NSDate *)dateTimeNow {
    NSDate* savedDate = [NSDate date];
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned components = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* comps = [gregorian components:components fromDate:savedDate];
    return [gregorian dateFromComponents:comps];
}

@end

NSString *const DateFormatKeyDateAndTimeInDefaultFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
NSString *const DateFormatKeyDayOfWeekAndMonthAndDay = @"cccc, LLLL d";
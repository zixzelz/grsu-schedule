//
//  ScheduleWeekServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "ScheduleWeekServices.h"
#import "DayScheduleParse.h"
#import "LessonScheduleParse.h"
#import "DaySchedule.h"
#import "LessonSchedule.h"
#import "Faculty.h"
#import "Specialization.h"
#import "Course.h"
#import "Group.h"
#import "DateUtils.h"

@implementation ScheduleWeekServices

- (void)scheduleWeekWithWeek:(Week *)week {
    NSArray *items = [self fetchDataWithItem:week];

    if (items.count > 0) {
        [self.delegate didLoadData:items error:nil];
    } else {
        [self loadDataWithItem:week callback:^(NSArray *array, NSError *error) {
            [self.delegate didLoadData:array error:error];
        }];
    }
}

- (void)loadDataWithItem:(Week *)week callback:(ArrayBlock)callback {
    Group *group = [week group];
    Course *course = [group course];
    Specialization *specialization = [course specialization];
    Faculty *faculty = [specialization faculty];
    
    [[Backend sharedInstance] loadScheduleWeekWithFacultyID:faculty.id specializationID:specialization.id courseID:course.id groupID:group.id weekID:week.id callback:^(NSArray *array, NSError *error) {
        NSMutableArray *result = [NSMutableArray array];
        for (DayScheduleParse *item in array) {
            DaySchedule *daySchedule;
            daySchedule = [NSEntityDescription insertNewObjectForEntityForName:[self entityDayName] inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            daySchedule.date = [DateUtils dateFromString:item.date format:@"dd.MM.yyyy"];
            daySchedule.week = week;
            [result addObject:daySchedule];
            for (LessonScheduleParse *lessonP in item.lessons) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                
                NSString *startTime = [[lessonP.time componentsSeparatedByString:@" - "] objectAtIndex:0];
                NSString *stopTime = [[lessonP.time componentsSeparatedByString:@" - "] objectAtIndex:1];

                LessonSchedule *lessonSchedule = [NSEntityDescription insertNewObjectForEntityForName:[self entityLessonScheduleName] inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
                lessonSchedule.groupTitle = lessonP.group;
                lessonSchedule.room = [numberFormatter numberFromString:lessonP.aud];
                lessonSchedule.location = lessonP.location;
                lessonSchedule.startTime = [DateUtils dateFromString:startTime format:@"HH:mm"];
                lessonSchedule.stopTime = [DateUtils dateFromString:stopTime format:@"HH:mm"];
                lessonSchedule.studyName = lessonP.disc;
                lessonSchedule.teacher = lessonP.teacher;
                lessonSchedule.daySchedule = daySchedule;
            }
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

- (NSArray *)fetchDataWithItem:(id)item {
    CacheManager *cacheManager = [CacheManager sharedInstance];
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", @"week", item];
    NSArray *items = [cacheManager sincCacheWithPredicate:predicate entity:[self entityDayName] sortDescriptors:sortDescriptors];
    
    return items;
}

#pragma mark - Override

- (NSString *)entityDayName {
    return @"DaySchedule";
}

- (NSString *)entityLessonScheduleName {
    return @"LessonSchedule";
}

@end

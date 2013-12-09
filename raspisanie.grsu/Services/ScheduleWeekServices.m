//
//  ScheduleWeekServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "ScheduleWeekServices.h"
#import "Faculty.h"
#import "Specialization.h"
#import "Course.h"
#import "Group.h"

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
        for (ScheduleItem *item in array) {
            Week *week;
            week = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            week.title = item.title;
            week.id = item.id;
            week.group = group;
            
            [result addObject:week];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

- (NSArray *)fetchDataWithItem:(id)item {
    CacheManager *cacheManager = [CacheManager sharedInstance];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"day" ascending:YES]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", @"week", item];
    NSArray *items = [cacheManager sincCacheWithPredicate:predicate entity:[self entityName] sortDescriptors:sortDescriptors];
    
    return items;
}

#pragma mark - Override

- (NSString *)entityName {
    return @"LessonSchedule";
}

@end

//
//  WeekServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "WeekServices.h"
#import "Faculty.h"
#import "Specialization.h"
#import "Course.h"
#import "Week.h"
#import "DateUtils.h"

@implementation WeekServices

- (void)weekItemsWithGroup:(Group *)group {
    NSArray *items = [self fetchDataWithItem:group];
    
    if (items.count > 0) {
        [self.delegate didLoadData:items error:nil];
    } else {
        [self loadDataWithItem:group callback:^(NSArray *array, NSError *error) {
            [self.delegate didLoadData:array error:error];
        }];
    }
}

- (void)loadDataWithItem:(Group *)group callback:(ArrayBlock)callback {
    Course *course = [group course];
    Specialization *specialization = [course specialization];
    Faculty *faculty = [specialization faculty];
    
    [[Backend sharedInstance] loadWeekItemsWithFacultyID:faculty.id specializationID:specialization.id courseID:course.id groupID:group.id callback:^(NSArray *array, NSError *error) {
        NSMutableArray *result = [NSMutableArray array];
        for (ScheduleItem *item in array) {
            Week *week;
            week = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            week.title = [DateUtils dateFromString:item.title format:@"dd.MM.yyyy"];
            week.id = item.id;
            week.group = group;
            
            [result addObject:week];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

#pragma mark - Override

- (NSString *)rootFieldName {
    return @"group";
}

- (NSString *)entityName {
    return @"Week";
}

@end

//
//  CourseServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "CourseServices.h"
#import "Faculty.h"
#import "Course.h"

@implementation CourseServices

- (void)courseItemsWithSpecialization:(Specialization *)specialization {
    NSArray *items = [self fetchDataWithItem:specialization];
    
    if (items.count > 0) {
        [self.delegate didLoadData:items error:nil];
    } else {
        [self loadDataWithItem:specialization callback:^(NSArray *array, NSError *error) {
            [self.delegate didLoadData:array error:error];
        }];
    }
}

- (void)loadDataWithItem:(Specialization *)specialization callback:(ArrayBlock)callback {
    Faculty *faculty = [specialization faculty];
    
    [[Backend sharedInstance] loadCourseItemsWithFacultyID:faculty.id specializationID:specialization.id callback:^(NSArray *array, NSError *error) {
        NSMutableArray *result = [NSMutableArray array];
        for (ScheduleItem *item in array) {
            Course *course;
            course = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            course.title = item.title;
            course.id = item.id;
            course.specialization = specialization;
            
            [result addObject:course];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

#pragma mark - Override

- (NSString *)rootFieldName {
    return @"specialization";
}

- (NSString *)entityName {
    return @"Course";
}

@end

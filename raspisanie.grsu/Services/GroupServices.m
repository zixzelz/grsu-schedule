//
//  GroupServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "GroupServices.h"
#import "Faculty.h"
#import "Specialization.h"
#import "Course.h"
#import "Group.h"

@implementation GroupServices

- (void)groupItemsWithCourse:(Course *)course {
    NSArray *items = [self fetchDataWithItem:course];
    
    if (items.count > 0) {
        [self.delegate didLoadData:items error:nil];
    } else {
        [self loadDataWithItem:course callback:^(NSArray *array, NSError *error) {
            [self.delegate didLoadData:array error:error];
        }];
    }
}

- (void)loadDataWithItem:(Course *)course callback:(ArrayBlock)callback {
    Specialization *specialization = [course specialization];
    Faculty *faculty = [specialization faculty];
    
    [[Backend sharedInstance] loadGroupItemsWithFacultyID:faculty.id specializationID:specialization.id courseID:course.id callback:^(NSArray *array, NSError *error) {
        NSMutableArray *result = [NSMutableArray array];
        for (ScheduleItem *item in array) {
            Group *group;
            group = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            group.title = item.title;
            group.id = item.id;
            group.course = course;
            
            [result addObject:group];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

#pragma mark - Override

- (NSString *)rootFieldName {
    return @"course";
}

- (NSString *)entityName {
    return @"Group";
}

@end

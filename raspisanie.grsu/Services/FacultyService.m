//
//  RaspisanieManager.m
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "FacultyService.h"

#define FACULTY_ENTITY_NAME @"Faculty"

@interface FacultyService ()

@end

@implementation FacultyService

#pragma mark -

- (void)facultyItems {
    NSArray *faculties = [self fetchDataWithItem:nil];
    
    if (faculties.count > 0) {
        [self.delegate didLoadData:faculties error:nil];
    } else {
        [self loadDataWithItem:nil callback:^(NSArray *array, NSError *error) {
            [self.delegate didLoadData:array error:error];
        }];
    }
}

- (void)loadDataWithItem:(id)item callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadFacultyItemsWithCallback:^(NSArray *array, NSError *error) {
        NSMutableArray *result = [NSMutableArray array];
        for (ScheduleItem *item in array) {
            Faculty *faculty;
            faculty = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            faculty.title = item.title;
            faculty.id = item.id;
            
            [result addObject:faculty];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

#pragma mark - Override

- (NSString *)entityName {
    return @"Faculty";
}

@end

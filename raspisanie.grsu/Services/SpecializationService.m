//
//  SpecializationService.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "SpecializationService.h"
#import "Specialization.h"

@implementation SpecializationService

- (void)specializationItemsWithFaculty:(Faculty *)faculty {
    NSArray *items = [self fetchDataWithItem:faculty];
    
    if (items.count > 0) {
        [self.delegate didLoadData:items error:nil];
    } else {
        [self loadDataWithItem:faculty callback:^(NSArray *array, NSError *error) {
            [self.delegate didLoadData:array error:error];
        }];
    }
}

- (void)loadDataWithItem:(Faculty *)faculty callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadSpecializationItemsWithFacultyID:faculty.id callback:^(NSArray *array, NSError *error) {
        NSMutableArray *result = [NSMutableArray array];
        for (ScheduleItem *item in array) {
            Specialization *specialization;
            specialization = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            specialization.title = item.title;
            specialization.id = item.id;
            specialization.faculty = faculty;
            
            [result addObject:specialization];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

#pragma mark - Override

- (NSString *)rootFieldName {
    return @"faculty";
}

- (NSString *)entityName {
    return @"Specialization";
}

@end

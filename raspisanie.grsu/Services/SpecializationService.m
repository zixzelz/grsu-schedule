//
//  SpecializationService.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "SpecializationService.h"
#import "Specialization.h"

#define SPECIALIZATION_ENTITY_NAME @"Specialization"

@implementation SpecializationService

- (void)specializationItemsWithFaculty:(Faculty *)faculty callback:(ArrayBlock)callback {
    NSArray *items = [self fetchSpecializationWithFaculty:faculty];
    
    if (items.count > 0) {
        callback(items, nil);
    } else {
        [self loadDataWithFaculty:faculty callback:callback];
    }

}

- (void)reloadDataWithFaculty:(Faculty *)faculty callback:(ArrayBlock)callback {
    [self removeSpecializationWithFaculty:faculty];
    [self loadDataWithFaculty:faculty callback:callback];
}

- (void)loadDataWithFaculty:(Faculty *)faculty callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadSpecializationItemsWithFacultyID:faculty.id callback:^(NSArray *array, NSError *error) {
        NSMutableArray *result = [NSMutableArray array];
        for (ScheduleItem *item in array) {
            Specialization *specialization;
            specialization = [NSEntityDescription insertNewObjectForEntityForName:SPECIALIZATION_ENTITY_NAME inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            specialization.title = item.title;
            specialization.id = item.id;
            specialization.faculty = faculty;
            
            [result addObject:specialization];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

- (void)removeSpecializationWithFaculty:(Faculty *)faculty {
    NSArray *items = [self fetchSpecializationWithFaculty:faculty];
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataConnection sharedInstance] managedObjectContext];
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
    }
}

- (NSArray *)fetchSpecializationWithFaculty:(Faculty *)faculty {
    CacheManager *cacheManager = [CacheManager sharedInstance];
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(faculty == %@)", faculty];
    NSArray *items = [cacheManager sincCacheWithPredicate:predicate entity:SPECIALIZATION_ENTITY_NAME sortDescriptors:sortDescriptors];
    
    return items;
}

@end

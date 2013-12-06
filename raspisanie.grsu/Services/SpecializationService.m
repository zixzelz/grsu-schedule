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

- (void)specializationItemsWithFacultyID:(NSString *)facultyID callback:(ArrayBlock)callback {
//    [[Backend sharedInstance] loadSpecializationItemsWithFacultyID:facultyID callback:callback];
    [self reloadDataWithFacultyID:facultyID callback:callback];
}

- (void)reloadDataWithFacultyID:(NSString *)facultyID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadSpecializationItemsWithFacultyID:facultyID callback:^(NSArray *array, NSError *error) {
//        [self removeAllFaculty];
        
        NSMutableArray *result = [NSMutableArray array];
        for (ScheduleItem *item in array) {
            Specialization *specialization;
            specialization = [NSEntityDescription insertNewObjectForEntityForName:SPECIALIZATION_ENTITY_NAME inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            specialization.title = item.title;
            specialization.id = item.id;
            
            [result addObject:specialization];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

//- (void)removeAllFaculty {
//    CacheManager *cacheManager = [CacheManager sharedInstance];
//    NSArray *faculties = [cacheManager sincCacheWithPredicate:nil entity:FACULTY_ENTITY_NAME];
//    
//    NSManagedObjectContext *managedObjectContext = [[CoreDataConnection sharedInstance] managedObjectContext];
//    for (NSManagedObject *managedObject in faculties) {
//        [managedObjectContext deleteObject:managedObject];
//    }
//}

//- (NSArray *)fetchAllFaculty {
//    CacheManager *cacheManager = [CacheManager sharedInstance];
//    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
//    NSArray *faculties = [cacheManager sincCacheWithPredicate:nil entity:FACULTY_ENTITY_NAME sortDescriptors:sortDescriptors];
//    
//    return faculties;
//}

@end

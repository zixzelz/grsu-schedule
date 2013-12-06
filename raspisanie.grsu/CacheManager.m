//
//  CacheManager.m
//  raspisanie.grsu
//
//  Created by Ruslan on 24.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "CacheManager.h"
#import "CoreDataConnection.h"
#import "FacultyMO.h"
#import "SpecializationMO.h"
#import "ReqState.h"

#define FACULTY_ENTITY_NAME @"Faculty"
#define SPECIALIZATION_ENTITY_NAME @"Specialization"
#define STATE_ENTITY_NAME @"ReqState"

@implementation CacheManager

static CacheManager *_instance;

+ (CacheManager *)sharedInstance {
    @synchronized(self) {
        if( _instance == nil ) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}

#pragma mark -
#pragma mark insert Faculty

- (void)insertFacultyWithItems:(NSArray *)items {
    for (FacultyItem *item in items) {
        [self insertFacultyNoSaveWithItem:item];
    }
    [[CoreDataConnection sharedInstance] saveContext];
}

- (void)insertFacultyWithItem:(FacultyItem *)item {
    [self insertFacultyNoSaveWithItem:item];
    [[CoreDataConnection sharedInstance] saveContext];
}

- (void)insertFacultyNoSaveWithItem:(FacultyItem *)item {
    FacultyMO *cache;
    cache = [NSEntityDescription insertNewObjectForEntityForName:FACULTY_ENTITY_NAME inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
    cache.title = item.title;
    cache.id = item.id;
}

#pragma mark -
#pragma mark insert Specialization

- (void)insertSpecializationWithItems:(NSArray *)items facultyID:(NSString *)facultyID {
    for (FacultyItem *item in items) {
        [self insertSpecializationNoSaveWithItem:item facultyID:facultyID];
    }
    [[CoreDataConnection sharedInstance] saveContext];
}

- (void)insertSpecializationWithItem:(FacultyItem *)item facultyID:(NSString *)facultyID {
    [self insertSpecializationNoSaveWithItem:item facultyID:facultyID];
    [[CoreDataConnection sharedInstance] saveContext];
}

- (void)insertSpecializationNoSaveWithItem:(FacultyItem *)item facultyID:(NSString *)facultyID {
    SpecializationMO *cache;
    cache = [NSEntityDescription insertNewObjectForEntityForName:SPECIALIZATION_ENTITY_NAME inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
    cache.title = item.title;
    cache.id = item.id;
    cache.facultyID = facultyID;
}

#pragma mark -
#pragma mark get Faculty

- (void)facultyItemsWithCallback:(ArrayBlock)callBack {
    [self cacheManagedObjectsWithPredicate:nil entity:FACULTY_ENTITY_NAME callBack:^(NSArray *array, NSError *error) {
        array = [self cacheWithCacheManagedObjects:array];
        dispatch_sync(dispatch_get_main_queue(), ^{
            callBack(array, error);
        });
    }];
}

#pragma mark -
#pragma mark store State

- (void)storeStateWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID viewState:(NSString *)viewState eventValidation:(NSString *)eventValidation {
    ReqState *cache;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(facultyID == %@) && (specializationID == %@) && (courseID == %@) && (groupID == %@) && (weekID == %@)",
                              facultyID ? facultyID : @"",
                              specializationID ? specializationID : @"",
                              courseID ? courseID : @"",
                              groupID ? groupID : @"",
                              weekID ? weekID : @""];
    
    NSArray *states = [self sincCacheWithPredicate:predicate entity:STATE_ENTITY_NAME];
    cache = [states lastObject];
    if (!cache) {
        cache = [NSEntityDescription insertNewObjectForEntityForName:STATE_ENTITY_NAME inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
        cache.facultyID = facultyID ? facultyID : @"";
        cache.specializationID = specializationID ? specializationID : @"";
        cache.courseID = courseID ? courseID : @"";
        cache.groupID = groupID ? groupID : @"";
        cache.weekID = weekID ? weekID : @"";
    }
    cache.viewState = viewState;
    cache.eventValidation = eventValidation;
    
    [[CoreDataConnection sharedInstance] saveContext];
}

#pragma mark -
#pragma mark get State

- (void)stateWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID callback:(StateBlock)callBack {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(facultyID == %@) && (specializationID == %@) && (courseID == %@) && (groupID == %@) && (weekID == %@)",
                              facultyID ? facultyID : @"",
                              specializationID ? specializationID : @"",
                              courseID ? courseID : @"",
                              groupID ? groupID : @"",
                              weekID ? weekID : @""];
    
    NSArray *states = [self sincCacheWithPredicate:predicate entity:STATE_ENTITY_NAME];
    ReqState *state = [states lastObject];
    callBack(state.viewState, state.eventValidation);
}

#pragma mark -
#pragma mark Managed Object

- (NSArray *)sincCacheWithPredicate:(NSPredicate *)predicate entity:(NSString *)entityName {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataConnection sharedInstance] managedObjectContext];
    NSError *error = nil;
    NSArray *mutableFetchResults = nil;
    mutableFetchResults = [managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"recived sinc rows: %d", mutableFetchResults.count);
    if (mutableFetchResults == nil) {
        // Error
        NSLog(@"cacheWithURL error %@, %@", error, [error userInfo]);
    }
    return mutableFetchResults;
}

- (void)cacheManagedObjectsWithPredicate:(NSPredicate *)predicate entity:(NSString *)entityName callBack:(ArrayBlock)callBack {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    [request setFetchBatchSize:25];
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataConnection sharedInstance] managedObjectContext];
    NSLog(@"pred performBlock");
    [managedObjectContext performBlock:^{
        NSError *error = nil;
        NSArray *mutableFetchResults = nil;
        mutableFetchResults = [managedObjectContext executeFetchRequest:request error:&error];
        NSLog(@"recived rows: %d", mutableFetchResults.count);
        if (mutableFetchResults == nil) {
            // Error
            NSLog(@"cacheWithURL error %@, %@", error, [error userInfo]);
        }
        callBack(mutableFetchResults, error);
    }];
}

#pragma mark Utils

- (NSArray *)cacheWithCacheManagedObjects:(NSArray *)cacheManagedObjects {
    NSMutableArray *items = [NSMutableArray array];
    for (FacultyMO *itemMO in cacheManagedObjects) {
        FacultyItem *item = [[FacultyItem alloc] init];
        item.id = itemMO.id;
        item.title = itemMO.title;
        [items addObject:item];
    }
    return [NSArray arrayWithArray:items];
}

@end

//
//  CacheManager.h
//  raspisanie.grsu
//
//  Created by Ruslan on 24.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleItem.h"

@interface CacheManager : NSObject

+ (CacheManager *)sharedInstance;

- (void)insertFacultyWithItems:(NSArray *)items;
- (void)insertFacultyWithItem:(ScheduleItem *)item;

- (void)insertSpecializationWithItems:(NSArray *)items facultyID:(NSString *)facultyID;
- (void)insertSpecializationWithItem:(ScheduleItem *)item facultyID:(NSString *)facultyID;

- (void)facultyItemsWithCallback:(ArrayBlock)callBack;


- (void)storeStateWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID viewState:(NSString *)viewState eventValidation:(NSString *)eventValidation;
- (void)stateWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID callback:(StateBlock)callBack;

- (NSArray *)sincCacheWithPredicate:(NSPredicate *)predicate entity:(NSString *)entityName;

@end

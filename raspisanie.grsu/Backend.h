//
//  Backend.h
//  raspisanie.grsu
//
//  Created by Ruslan on 25.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Backend : NSObject

+ (Backend *)sharedInstance;

- (void)loadFacultyItemsWithCallback:(ArrayBlock)callback;
- (void)loadSpecializationItemsWithFacultyID:(NSString *)facultyID callback:(ArrayBlock)callback;
- (void)loadCourseItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID callback:(ArrayBlock)callback;
- (void)loadGroupItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID callback:(ArrayBlock)callback;
- (void)loadWeekItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID callback:(ArrayBlock)callback;
- (void)loadScheduleWeekWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID callback:(ArrayBlock)callback;

@end

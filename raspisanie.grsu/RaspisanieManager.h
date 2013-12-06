//
//  RaspisanieManager.h
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RaspisanieManager : NSObject

+ (RaspisanieManager *)sharedInstance;
- (void)facultyItemsWithCallback:(ArrayBlock)callback;
- (void)specializationItemsWithFacultyID:(NSString *)facultyID callback:(ArrayBlock)callback;
- (void)courseItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID callback:(ArrayBlock)callback;
- (void)groupItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID callback:(ArrayBlock)callback;
- (void)weekItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID callback:(ArrayBlock)callback;
- (void)scheduleWeekWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID callback:(ArrayBlock)callback;

@end

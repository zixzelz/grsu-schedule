//
//  ScheduleWeekServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "ScheduleWeekServices.h"

@implementation ScheduleWeekServices

- (void)scheduleWeekWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadScheduleWeekWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:weekID callback:callback];
    //    [self performRequestWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:weekID callback:^(NSString *html, NSError *error) {
    //        NSArray *array = [FacultyHTMLParser scheduleParseWithHTML:html];
    //        callback(array, error);
    //    }];
}

@end

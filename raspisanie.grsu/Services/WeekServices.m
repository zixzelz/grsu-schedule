//
//  WeekServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "WeekServices.h"

@implementation WeekServices

- (void)weekItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadWeekItemsWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID callback:callback];
    //    [self performRequestWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:nil callback:^(NSString *html, NSError *error) {
    //        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_WEEK];
    //        callback(array, error);
    //    }];
}

@end

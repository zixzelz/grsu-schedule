//
//  CourseServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "CourseServices.h"

@implementation CourseServices

- (void)courseItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadCourseItemsWithFacultyID:facultyID specializationID:specializationID callback:callback];
    //    [self performRequestWithFacultyID:facultyID specializationID:specializationID courseID:nil groupID:nil weekID:nil callback:^(NSString *html, NSError *error) {
    //        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_COURSE];
    //        callback(array, error);
    //    }];
}

@end

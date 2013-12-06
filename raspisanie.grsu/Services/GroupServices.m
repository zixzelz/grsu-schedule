//
//  GroupServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "GroupServices.h"

@implementation GroupServices

- (void)groupItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadGroupItemsWithFacultyID:facultyID specializationID:specializationID courseID:courseID callback:callback];
    //    [self performRequestWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:nil weekID:nil callback:^(NSString *html, NSError *error) {
    //        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_GROUP];
    //        callback(array, error);
    //    }];
}

@end

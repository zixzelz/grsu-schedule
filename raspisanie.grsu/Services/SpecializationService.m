//
//  SpecializationService.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "SpecializationService.h"

@implementation SpecializationService

- (void)specializationItemsWithFacultyID:(NSString *)facultyID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadSpecializationItemsWithFacultyID:facultyID callback:callback];
}

@end

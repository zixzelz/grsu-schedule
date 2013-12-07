//
//  CourseServices.h
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "BaseServices.h"

@interface CourseServices : BaseServices

- (void)courseItemsWithSpecialization:(NSString *)specializationID callback:(ArrayBlock)callback;

@end

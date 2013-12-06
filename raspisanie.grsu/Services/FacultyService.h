//
//  RaspisanieManager.h
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "BaseServices.h"
#import "Faculty.h"

@interface FacultyService : BaseServices

- (void)facultyItemsWithCallback:(ArrayBlock)callback;

@end

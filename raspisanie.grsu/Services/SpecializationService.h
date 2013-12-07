//
//  SpecializationService.h
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "BaseServices.h"
#import "Faculty.h"

@interface SpecializationService : BaseServices

- (void)specializationItemsWithFaculty:(Faculty *)faculty;
- (void)reloadDataWithFaculty:(Faculty *)faculty;

@end

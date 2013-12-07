//
//  GroupServices.h
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "BaseServices.h"
#import "Course.h"

@interface GroupServices : BaseServices

- (void)groupItemsWithCourse:(Course *)course;

@end

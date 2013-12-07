//
//  WeekServices.h
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "BaseServices.h"
#import "Group.h"

@interface WeekServices : BaseServices

- (void)weekItemsWithGroup:(Group *)group;

@end

//
//  WeekViewController.h
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItem.h"

@interface WeekViewController : UIViewController

- (id)initWithFacultyItem:(ScheduleItem *)facultyItem specializationItem:(ScheduleItem *)specializationItem courseItem:(ScheduleItem *)courseItem groupItem:(ScheduleItem *)groupItem;

@end

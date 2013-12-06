//
//  CourseViewController.h
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleItem.h"

@interface CourseViewController : UIViewController

- (id)initWithFacultyItem:(ScheduleItem *)facultyItem specializationItem:(ScheduleItem *)specializationItem;

@end

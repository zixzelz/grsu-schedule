//
//  ScheduleViewController.h
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaySchedule.h"
#import "ScheduleItem.h"

@interface ScheduleViewController : UIViewController

@property (nonatomic, strong, readonly) DaySchedule *daySchedule;

- (id)initWithDaySchedule:(DaySchedule *)daySchedule;

@end

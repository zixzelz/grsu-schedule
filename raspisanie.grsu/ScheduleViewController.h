//
//  ScheduleViewController.h
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Week.h"
#import "ScheduleItem.h"

@interface ScheduleViewController : UIViewController

- (id)initWithWeekItem:(Week *)weekItem;

@end

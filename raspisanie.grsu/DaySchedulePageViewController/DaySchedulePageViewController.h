//
//  DaySchedulePageViewController.h
//  raspisanie.grsu
//
//  Created by Ruslan on 03.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Group;

@interface DaySchedulePageViewController : UIPageViewController

- (id)initWithGroupItem:(Group *)groupItem;

@end

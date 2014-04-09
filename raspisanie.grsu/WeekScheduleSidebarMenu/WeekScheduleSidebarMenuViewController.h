//
//  WeekScheduleSidebarMenuViewController.h
//  raspisanie.grsu
//
//  Created by Ruslan on 06.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeekScheduleSidebarMenuDelegate;
@class Week;

@interface WeekScheduleSidebarMenuViewController : UIViewController

@property (nonatomic, weak) id<WeekScheduleSidebarMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *weeks;

@end


@protocol WeekScheduleSidebarMenuDelegate <NSObject>

- (void)weekScheduleSidebarMenu:(WeekScheduleSidebarMenuViewController *)vc didSelectWeek:(Week *)week;

@end
//
//  DaySchedulePageViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 03.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import "DaySchedulePageViewController.h"
#import "DaySchedule.h"
#import "LessonSchedule.h"
#import "ScheduleViewController.h"
#import "Week.h"
#import "ScheduleWeekServices.h"
#import "ColorUtils.h"

@interface DaySchedulePageViewController () <UIPageViewControllerDataSource, BaseServicesDelegate>

@property (nonatomic, strong) Week *weekItem;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSArray *scheduleDays;
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) ScheduleWeekServices *service;

@end


@implementation DaySchedulePageViewController

- (id)initWithWeekItem:(Week *)weekItem {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@(20)}];
    if (self) {
        self.weekItem = weekItem;

        self.title = @"Расписание";
        self.dataSource = self;
        self.pageIndex = 0;

        [self setupService];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0x2A303B);;
    self.loadingView = [[LoadingView alloc] initWithView:self.view];
    [self fetchData];
}

#pragma mark - Service

- (void)setupService {
    self.service = [ScheduleWeekServices new];
    self.service.delegate = self;
}

- (void)fetchData {
    [self.loadingView showLoading];
    [self.service scheduleWeekWithWeek:self.weekItem];
}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    [self.loadingView hideLoading];
    self.scheduleDays = items;
    
    UIViewController *vc = [self scheduleViewControllerWithDaySchedule:items[self.pageIndex]];
    [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if (self.pageIndex == 0) {
        return nil;
    }
    self.pageIndex--;
    DaySchedule *daySchedule = self.scheduleDays[self.pageIndex];
    UIViewController *vc = [self scheduleViewControllerWithDaySchedule:daySchedule];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if (self.pageIndex == self.scheduleDays.count - 1) {
        return nil;
    }
    self.pageIndex++;
    DaySchedule *daySchedule = self.scheduleDays[self.pageIndex];
    UIViewController *vc = [self scheduleViewControllerWithDaySchedule:daySchedule];
    return vc;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 7;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma mark - Utils

- (UIViewController *)scheduleViewControllerWithDaySchedule:(DaySchedule *)daySchedule {
    ScheduleViewController *controller = [[ScheduleViewController alloc] initWithDaySchedule:daySchedule];
    return controller;
}

@end

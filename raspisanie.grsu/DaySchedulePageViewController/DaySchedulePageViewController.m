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
#import "WeekServices.h"
#import "ScheduleWeekServices.h"
#import "ColorUtils.h"
#import "MainSidebarController.h"
#import "WeekScheduleSidebarMenuViewController.h"

@interface DaySchedulePageViewController () <UIPageViewControllerDataSource, BaseServicesDelegate>

@property (nonatomic, strong) Group *groupItem;
@property (nonatomic, strong) Week *weekItem;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSArray *scheduleDays;
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) ScheduleWeekServices *service;

@end


@implementation DaySchedulePageViewController

- (id)initWithGroupItem:(Group *)groupItem {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:@{UIPageViewControllerOptionInterPageSpacingKey:@(20)}];
    if (self) {
        self.groupItem = groupItem;

        self.title = @"Расписание";
        self.dataSource = self;
        self.pageIndex = 0;

        [self setupService];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWeekSidebarMenu];
    self.view.backgroundColor = UIColorFromRGB(0x2A303B);
    self.loadingView = [[LoadingView alloc] initWithView:self.view];
    
    [self fetchWeekData];
}

- (void)setupWeekSidebarMenu {
    WeekScheduleSidebarMenuViewController *rightVC = [WeekScheduleSidebarMenuViewController new];
    MainSidebarController *sidebarController = (id)[self sidebarController];
    [sidebarController setRightViewController:rightVC];
    
    UIImage *imgRight = [UIImage imageNamed:@"CalendarIcon"];
    UIBarButtonItem* barButtonRight = [[UIBarButtonItem alloc] initWithImage:imgRight style:UIBarButtonItemStylePlain target:self action:@selector(rightSidebarButtonClicked:)];
    [self.navigationItem setRightBarButtonItem:barButtonRight];
}

- (void)rightSidebarButtonClicked:(UIBarButtonItem *)barButtonItem {
    MainSidebarController *sidebarController = (id)[self sidebarController];
    if (sidebarController.currentVisibleSubPage != SubPageTypeRight) {
        [sidebarController showRightViewControllerAnimated:YES];
    } else {
        [sidebarController hideCurrentViewControllerAnimated:YES];
    }
}

#pragma mark - Service

- (void)setupService {
    self.service = [ScheduleWeekServices new];
    self.service.delegate = self;
}

- (void)fetchWeekData {
    [self.loadingView showLoading];
    
    WeekServices *service = [WeekServices new];
    [service setResponseCallback:^(NSArray *array, NSError *error) {
        Week *weak = array[0];
        [self fetchScheduleDataWithWeak:weak];
    }];
    
    [service weekItemsWithGroup:self.groupItem];
}

- (void)fetchScheduleDataWithWeak:(Week *)week {
    [self.loadingView showLoading];
    [self.service scheduleWeekWithWeek:week];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ScheduleViewController *)viewController {
    NSInteger pageIndex = [self.scheduleDays indexOfObject:viewController.daySchedule];
    if (pageIndex == 0) {
        return nil;
    }
    NSLog(@"load Before view %ld", (long)pageIndex);
    pageIndex--;
    DaySchedule *daySchedule = self.scheduleDays[pageIndex];
    UIViewController *vc = [self scheduleViewControllerWithDaySchedule:daySchedule];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ScheduleViewController *)viewController {
    NSInteger pageIndex = [self.scheduleDays indexOfObject:viewController.daySchedule];
    if (pageIndex == self.scheduleDays.count - 1) {
        return nil;
    }
    NSLog(@"load After view %ld", (long)pageIndex);
    pageIndex++;
    DaySchedule *daySchedule = self.scheduleDays[pageIndex];
    UIViewController *vc = [self scheduleViewControllerWithDaySchedule:daySchedule];
    return vc;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return self.scheduleDays.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return self.pageIndex;
}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    [self.loadingView hideLoading];
    
    self.scheduleDays = items;
    NSDate *toDay = [self startDayWithDate:[NSDate date]];
    for (DaySchedule *daySchedule in items) {
        if ([daySchedule.date compare:toDay] == NSOrderedSame) {
            self.pageIndex = [items indexOfObject:daySchedule];
            break;
        }
    }
    
    [self reloadInputViews];
    UIViewController *vc = [self scheduleViewControllerWithDaySchedule:items[self.pageIndex]];
    [self setViewControllers:@[vc] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - Utils

- (UIViewController *)scheduleViewControllerWithDaySchedule:(DaySchedule *)daySchedule {
    ScheduleViewController *controller = [[ScheduleViewController alloc] initWithDaySchedule:daySchedule];
    return controller;
}

- (NSDate *)startDayWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:kCFCalendarUnitYear | kCFCalendarUnitMonth | kCFCalendarUnitDay fromDate:date];
    NSDate *startDay = [calendar dateFromComponents:components];
    
    return startDay;
}

@end

//
//  ScheduleViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleWeekServices.h"
#import "DaySchedule.h"
#import "LessonSchedule.h"
#import "LessonScheduleCell.h"
#import "DateUtils.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate, BaseServicesDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *scheduleDays;

@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) ScheduleWeekServices *service;

@property (nonatomic, strong) Week *weekItem;

@end

@implementation ScheduleViewController

- (id)initWithWeekItem:(Week *)weekItem {
    self = [super init];
    if (self) {
        self.title = @"Расписание";
        self.weekItem = weekItem;
        [self setupRefreshControl];
        [self setupService];
    }
    return self;
}

- (void)setupService {
    self.service = [ScheduleWeekServices new];
    self.service.delegate = self;
}

- (void)setupRefreshControl {
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView = [[LoadingView alloc] initWithView:self.view];
    
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path) {
        [self.tableView deselectRowAtIndexPath:path animated:YES]; // Hide selected
    }
}

#pragma mark CourseServices

- (void)fetchData {
    [self.loadingView showLoading];
    [self.service scheduleWeekWithWeek:self.weekItem];
}

- (void)reloadData {
    [self.loadingView showLoading];
    [self.service reloadDataWithItem:self.weekItem];
}

#pragma mark -

- (void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.scheduleDays.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DaySchedule *day = self.scheduleDays[section];
    return day.lessons.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DaySchedule *day = self.scheduleDays[section];
    return [DateUtils formatDate:day.date withFormat:DateFormatDayMonthYear];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LessonScheduleCell";
    
    LessonScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DaySchedule *day = self.scheduleDays[indexPath.section];
    LessonSchedule *lesson = [day.lessons objectAtIndex:indexPath.row];
    
    cell.startTime.text = [NSString stringWithFormat:@"%@", lesson.startTime];
    cell.stopTime.text = [NSString stringWithFormat:@"%@", lesson.stopTime];
    cell.studyName.text = lesson.studyName;
    cell.teacher.text = lesson.teacher;
    cell.location.text = [NSString stringWithFormat:@"%@; %@", lesson.location, lesson.room];

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DaySchedule *day = self.scheduleDays[indexPath.section];
//    LessonSchedule *lesson = day.lessons[indexPath.row];
//
//    return [LessonScheduleCell heightForSmallCellWithText:lesson.disc tableWidth:self.tableView.bounds.size.width];
//}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    [self.loadingView hideLoading];
    [self.refreshControl endRefreshing];
    self.scheduleDays = items;
    [self.tableView reloadData];
}

@end

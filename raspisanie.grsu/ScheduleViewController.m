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
#import "LessonScheduleCell.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *scheduleDays;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) ScheduleItem *facultyItem;
@property (nonatomic, strong) ScheduleItem *specializationItem;
@property (nonatomic, strong) ScheduleItem *courseItem;
@property (nonatomic, strong) ScheduleItem *groupItem;
@property (nonatomic, strong) ScheduleItem *weekItem;

@end

@implementation ScheduleViewController

- (id)initWithFacultyItem:(ScheduleItem *)facultyItem specializationItem:(ScheduleItem *)specializationItem courseItem:(ScheduleItem *)courseItem groupItem:(ScheduleItem *)groupItem weekItem:(ScheduleItem *)weekItem {
    self = [super init];
    if (self) {
        self.title = @"Расписание";
        self.facultyItem = facultyItem;
        self.specializationItem = specializationItem;
        self.courseItem = courseItem;
        self.groupItem = groupItem;
        self.weekItem = weekItem;
        [self loadCourseWithFacultyID:facultyItem.id specializationID:specializationItem.id courseID:courseItem.id groupID:groupItem.id weekID:weekItem.id];
    }
    return self;
}

- (void)loadCourseWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID {
    ScheduleWeekServices *service = [ScheduleWeekServices new];
    [service scheduleWeekWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:weekID callback:^(NSArray *array, NSError *error) {
        [self.loadingView hideLoading];
        self.scheduleDays = array;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.scheduleDays) {
        self.loadingView = [[LoadingView alloc] initWithView:self.view];
        [self.loadingView showLoading];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path) {
        [self.tableView deselectRowAtIndexPath:path animated:YES]; // Hide selected
    }
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
    return day.title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LessonScheduleCell";
    
    LessonScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DaySchedule *day = self.scheduleDays[indexPath.section];
    LessonSchedule *lesson = day.lessons[indexPath.row];
    
    [cell setTimeText:lesson.time];
    [cell setAudText:lesson.aud];
    [cell setDiscText:lesson.disc];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DaySchedule *day = self.scheduleDays[indexPath.section];
    LessonSchedule *lesson = day.lessons[indexPath.row];

    return [LessonScheduleCell heightForSmallCellWithText:lesson.disc tableWidth:self.tableView.bounds.size.width];
}

@end

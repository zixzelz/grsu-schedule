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
#import "ColorUtils.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) DaySchedule *daySchedule;

@end

@implementation ScheduleViewController

- (id)initWithDaySchedule:(DaySchedule *)daySchedule {
    self = [super init];
    if (self) {
        self.title = @"Расписаниеqqq";
        self.daySchedule = daySchedule;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    [self.tableView setContentInset:inset];
    [self.tableView setScrollIndicatorInsets:inset];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DaySchedule *day = self.daySchedule;
    return day.lessons.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    DaySchedule *day = self.daySchedule;
    return [DateUtils formatDate:day.date withFormat:DateFormatDayMonthYear];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"LessonScheduleCell";
    
    LessonScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    DaySchedule *day = self.daySchedule;
    LessonSchedule *lesson = day.lessons[indexPath.row];
    
    cell.startTime.text = [DateUtils formatDate:lesson.startTime withFormat:DateFormatTimeOnly];
    cell.stopTime.text = [DateUtils formatDate:lesson.stopTime withFormat:DateFormatTimeOnly];
    cell.studyName.text = lesson.studyName;
    cell.teacher.text = lesson.teacher;
    cell.location.text = [NSString stringWithFormat:@"%@; %@", lesson.location, lesson.room];

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    header.contentView.backgroundColor = UIColorFromRGB(0x2A303B);
    header.textLabel.textColor = [UIColor whiteColor];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    DaySchedule *day = self.scheduleDays[indexPath.section];
//    LessonSchedule *lesson = day.lessons[indexPath.row];
//
//    return [LessonScheduleCell heightForSmallCellWithText:lesson.disc tableWidth:self.tableView.bounds.size.width];
//}

@end

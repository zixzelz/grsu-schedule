//
//  WeekViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "WeekViewController.h"
#import "RaspisanieManager.h"
#import "ScheduleViewController.h"

@interface WeekViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *weekItems;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) FacultyItem *facultyItem;
@property (nonatomic, strong) FacultyItem *specializationItem;
@property (nonatomic, strong) FacultyItem *courseItem;
@property (nonatomic, strong) FacultyItem *groupItem;

@end

@implementation WeekViewController

- (id)initWithFacultyItem:(FacultyItem *)facultyItem specializationItem:(FacultyItem *)specializationItem courseItem:(FacultyItem *)courseItem groupItem:(FacultyItem *)groupItem {
    self = [super init];
    if (self) {
        self.title = @"Неделя с";
        self.facultyItem = facultyItem;
        self.specializationItem = specializationItem;
        self.courseItem = courseItem;
        self.groupItem = groupItem;
        [self loadCourseWithFacultyID:facultyItem.id specializationID:specializationItem.id courseID:courseItem.id groupID:groupItem.id];
    }
    return self;
}

- (void)loadCourseWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID {
    [[RaspisanieManager sharedInstance] weekItemsWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID callback:^(NSArray *array, NSError *error) {
        [self.loadingView hideLoading];
        self.weekItems = array;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.weekItems) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weekItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FacultyItem *item = self.weekItems[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FacultyItem *item = self.weekItems[indexPath.row];
    
    ScheduleViewController *controller = [[ScheduleViewController alloc] initWithFacultyItem:self.facultyItem specializationItem:self.specializationItem courseItem:self.courseItem groupItem:self.groupItem weekItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

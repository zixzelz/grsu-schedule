//
//  GroupViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupServices.h"
#import "WeekViewController.h"

@interface GroupViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *groupItems;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) ScheduleItem *facultyItem;
@property (nonatomic, strong) ScheduleItem *specializationItem;
@property (nonatomic, strong) ScheduleItem *courseItem;

@end

@implementation GroupViewController

- (id)initWithFacultyItem:(ScheduleItem *)facultyItem specializationItem:(ScheduleItem *)specializationItem courseItem:(ScheduleItem *)courseItem {
    self = [super init];
    if (self) {
        self.title = @"Группа";
        self.facultyItem = facultyItem;
        self.specializationItem = specializationItem;
        self.courseItem = courseItem;
        [self loadCourseWithFacultyID:facultyItem.id specializationID:specializationItem.id courseID:courseItem.id];
    }
    return self;
}

- (void)loadCourseWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID {
    GroupServices *service = [GroupServices new];
    [service groupItemsWithFacultyID:facultyID specializationID:specializationID courseID:courseID callback:^(NSArray *array, NSError *error) {
        [self.loadingView hideLoading];
        self.groupItems = array;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.groupItems) {
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
    return self.groupItems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ScheduleItem *item = self.groupItems[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleItem *item = self.groupItems[indexPath.row];
    
    WeekViewController *controller = [[WeekViewController alloc] initWithFacultyItem:self.facultyItem specializationItem:self.specializationItem courseItem:self.courseItem groupItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

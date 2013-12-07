//
//  CourseViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "CourseViewController.h"
#import "CourseServices.h"
#import "GroupViewController.h"
#import "Course.h"

@interface CourseViewController () <UITableViewDataSource, UITableViewDelegate, BaseServicesDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) CourseServices *service;

@property (nonatomic, strong) NSArray *courseItems;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) Specialization *specializationItem;

@end

@implementation CourseViewController

- (id)initWithSpecializationItem:(Specialization *)specialization {
    self = [super init];
    if (self) {
        self.title = @"Курс";
        self.specializationItem = specialization;
        [self setupService];
        [self setupRefreshControl];
    }
    return self;
}

- (void)setupService {
    self.service = [CourseServices new];
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
    [self.service courseItemsWithSpecialization:self.specializationItem];
}

- (void)reloadData {
    [self.loadingView showLoading];
    [self.service reloadDataWithItem:self.specializationItem];
}

#pragma mark -

- (void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self reloadData];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseItems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ScheduleItem *item = self.courseItems[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleItem *item = self.courseItems[indexPath.row];
    
//    GroupViewController *controller = [[GroupViewController alloc] initWithFacultyItem:self.facultyItem specializationItem:self.specializationItem courseItem:item];
//    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    [self.loadingView hideLoading];
    [self.refreshControl endRefreshing];
    self.courseItems = items;
    [self.tableView reloadData];
}

@end

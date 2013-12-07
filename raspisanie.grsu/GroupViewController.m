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
#import "Group.h"

@interface GroupViewController () <UITableViewDataSource, UITableViewDelegate, BaseServicesDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) GroupServices *service;

@property (nonatomic, strong) NSArray *groupItems;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) Course *courseItem;

@end

@implementation GroupViewController

- (id)initWithCourseItem:(Course *)courseItem {
    self = [super init];
    if (self) {
        self.title = @"Группа";
        self.courseItem = courseItem;
        [self setupRefreshControl];
        [self setupService];
    }
    return self;
}

- (void)setupService {
    self.service = [GroupServices new];
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
    [self.service groupItemsWithCourse:self.courseItem];
}

- (void)reloadData {
    [self.loadingView showLoading];
    [self.service reloadDataWithItem:self.courseItem];
}

#pragma mark -

- (void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self reloadData];
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
    
    Group *item = self.groupItems[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Group *item = self.groupItems[indexPath.row];
    
    WeekViewController *controller = [[WeekViewController alloc] initWithGroupItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    [self.loadingView hideLoading];
    [self.refreshControl endRefreshing];
    self.groupItems = items;
    [self.tableView reloadData];
}

@end

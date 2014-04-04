//
//  WeekViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "WeekViewController.h"
#import "WeekServices.h"
#import "ScheduleViewController.h"
#import "Week.h"
#import "DateUtils.h"

#import "DaySchedulePageViewController.h"

@interface WeekViewController () <UITableViewDataSource, UITableViewDelegate, BaseServicesDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) WeekServices *service;

@property (nonatomic, strong) NSArray *weekItems;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) Group *groupItem;

@end

@implementation WeekViewController

- (id)initWithGroupItem:(Group *)groupItem {
    self = [super init];
    if (self) {
        self.title = @"Неделя с";
        self.groupItem = groupItem;
        [self setupRefreshControl];
        [self setupService];
    }
    return self;
}

- (void)setupService {
    self.service = [WeekServices new];
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
    [self.service weekItemsWithGroup:self.groupItem];
}

- (void)reloadData {
    [self.loadingView showLoading];
    [self.service reloadDataWithItem:self.groupItem];
}

#pragma mark -

- (void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self reloadData];
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
    
    Week *item = self.weekItems[indexPath.row];
    cell.textLabel.text = [DateUtils formatDate:item.title withFormat:DateFormatDayMonthYear];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Week *item = self.weekItems[indexPath.row];
    
//    ScheduleViewController *controller = [[ScheduleViewController alloc] initWithWeekItem:item];
    DaySchedulePageViewController *controller = [[DaySchedulePageViewController alloc] initWithWeekItem:item];
    
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    [self.loadingView hideLoading];
    [self.refreshControl endRefreshing];
    self.weekItems = items;
    [self.tableView reloadData];
}

@end

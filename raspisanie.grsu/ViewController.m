//
//  ViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "ViewController.h"
#import "FacultyService.h"
#import "SpecializationViewController.h"
#import "Faculty.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, BaseServicesDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) FacultyService *service;
@property (nonatomic, strong) NSArray *facultyItems;

@end


@implementation ViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupService];
        [self setupRefreshControl];
    }
    return self;
}

- (void)setupService {
    self.service = [FacultyService new];
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
    [self.tableView addSubview:self.refreshControl];
    self.loadingView = [[LoadingView alloc] initWithView:self.view];
    self.title = @"Факультет (отделение)";
    
    [self fetchData];
}

#pragma mark SpecializationService

- (void)fetchData {
    [self.loadingView showLoading];
    [self.service facultyItems];
}

- (void)reloadData {
    [self.loadingView showLoading];
    [self.service reloadDataWithItem:nil];
}

#pragma mark - UIRefreshControl

- (void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    [self reloadData];
    
    // custom refresh logic would be placed here...
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"MMM d, h:mm a"];
    //    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@",
    //                             [formatter stringFromDate:[NSDate date]]];
    //    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.facultyItems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ScheduleItem *item = self.facultyItems[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Faculty *item = self.facultyItems[indexPath.row];

    SpecializationViewController *controller = [[SpecializationViewController alloc] initWithFacultyItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    [self.loadingView hideLoading];
    [self.refreshControl endRefreshing];
    self.facultyItems = items;
    [self.tableView reloadData];
}

@end












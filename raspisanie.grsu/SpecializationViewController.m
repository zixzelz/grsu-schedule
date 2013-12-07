//
//  SpecializationViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 16.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "SpecializationViewController.h"
#import "SpecializationService.h"
#import "CourseViewController.h"
#import "Specialization.h"

@interface SpecializationViewController () <UITableViewDataSource, UITableViewDelegate, BaseServicesDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSArray *specializationItems;
@property (nonatomic, strong) SpecializationService *service;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) Faculty *facultyItem;

@end

@implementation SpecializationViewController 

- (id)initWithFacultyItem:(Faculty *)facultyItem {
    self = [super init];
    if (self) {
        self.title = @"Специальность";
        self.facultyItem = facultyItem;
        [self setupService];
        [self setupRefreshControl];
    }
    return self;
}

- (void)setupService {
    self.service = [SpecializationService new];
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

    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path) {
        [self.tableView deselectRowAtIndexPath:path animated:YES]; // Hide selected
    }
}

#pragma mark SpecializationService

- (void)fetchData {
    [self.loadingView showLoading];
    [self.service specializationItemsWithFaculty:self.facultyItem];
}

- (void)reloadData {
    [self.loadingView showLoading];
    [self.service reloadDataWithFaculty:self.facultyItem];
}

#pragma mark -

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
    return self.specializationItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Specialization *item = self.specializationItems[indexPath.row];
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleItem *item = self.specializationItems[indexPath.row];
    
    CourseViewController *controller = [[CourseViewController alloc] initWithFacultyItem:self.facultyItem specializationItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    [self.loadingView hideLoading];
    [self.refreshControl endRefreshing];
    self.specializationItems = items;
    [self.tableView reloadData];
}

@end

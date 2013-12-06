//
//  SpecializationViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 16.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "SpecializationViewController.h"
#import "RaspisanieManager.h"
#import "CourseViewController.h"

@interface SpecializationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *specializationItems;
@property (nonatomic, strong) LoadingView *loadingView;

@property (nonatomic, strong) FacultyItem *facultyItem;

@end

@implementation SpecializationViewController 

- (id)initWithFacultyItem:(FacultyItem *)facultyItem {
    self = [super init];
    if (self) {
        self.title = @"Специальность";
        self.facultyItem = facultyItem;
        [self loadSpecializationWithFacultyID:facultyItem.id];
    }
    return self;
}

- (void)loadSpecializationWithFacultyID:(NSString *)facultyID {
    [[RaspisanieManager sharedInstance] specializationItemsWithFacultyID:facultyID callback:^(NSArray *array, NSError *error) {
        [self.loadingView hideLoading];
        self.specializationItems = array;
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.specializationItems) {
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
    return self.specializationItems.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FacultyItem *item = self.specializationItems[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FacultyItem *item = self.specializationItems[indexPath.row];
    
    CourseViewController *controller = [[CourseViewController alloc] initWithFacultyItem:self.facultyItem specializationItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}

@end

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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *facultyItems;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Факультет (отделение)";
    
    LoadingView *loadingView = [[LoadingView alloc] initWithView:self.view];
    [loadingView showLoading];
    
    FacultyService *facultyService = [FacultyService new];
    [facultyService facultyItemsWithCallback:^(NSArray *array, NSError *error) {
        [loadingView hideLoading];
        self.facultyItems = array;
        [self.tableView reloadData];
    }];
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
    ScheduleItem *item = self.facultyItems[indexPath.row];

    SpecializationViewController *controller = [[SpecializationViewController alloc] initWithFacultyItem:item];
    [self.navigationController pushViewController:controller animated:YES];
}

@end













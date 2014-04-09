//
//  WeekScheduleSidebarMenuViewController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 06.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import "WeekScheduleSidebarMenuViewController.h"
#import "Week.h"
#import "DateUtils.h"
#import "BaseSidebarController.h"

@interface WeekScheduleSidebarMenuViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end


@implementation WeekScheduleSidebarMenuViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.weeks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"WeekScheduleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = self.view.backgroundColor;
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    Week *item = self.weeks[indexPath.row];
    cell.textLabel.text = [DateUtils formatDate:item.title withFormat:DateFormatDayMonth];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[self sidebarController] hideCurrentViewControllerAnimated:YES];
    [self.delegate weekScheduleSidebarMenu:self didSelectWeek:self.weeks[indexPath.row]];
}

@end

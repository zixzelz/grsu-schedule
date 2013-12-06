//
//  FacultyItem.m
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "ScheduleItem.h"

@implementation ScheduleItem

+ (ScheduleItem *)faculityItemWithId:(NSString *)id_ title:(NSString *)title {
    ScheduleItem *item = [[ScheduleItem alloc] init];
    item.id = id_;
    item.title = title;
    return item;
}

@end

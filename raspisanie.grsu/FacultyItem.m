//
//  FacultyItem.m
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "FacultyItem.h"

@implementation FacultyItem

+ (FacultyItem *)faculityItemWithId:(NSString *)id_ title:(NSString *)title {
    FacultyItem *item = [[FacultyItem alloc] init];
    item.id = id_;
    item.title = title;
    return item;
}

@end

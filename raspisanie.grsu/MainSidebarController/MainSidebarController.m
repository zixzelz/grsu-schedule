//
//  MainSidebarController.m
//  raspisanie.grsu
//
//  Created by Ruslan on 06.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import "MainSidebarController.h"
#import "SpecializationViewController.h"

@implementation MainSidebarController

- (instancetype)init {
    self = [super init];
    if (self) {
        SpecializationViewController *viewController = (id)[[SpecializationViewController alloc] init];
        [self setRootViewController:viewController animated:NO withNavigationController:YES];
    }
    return self;
}

@end

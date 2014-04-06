//
//  UIViewController+HBSidebarControllerItem.m
//  HelpBook
//
//  Created by Ruslan Maslouski on 3/20/14.
//  Copyright (c) 2014 HelpBook Inc. All rights reserved.
//

#import "UIViewController+HBSidebarControllerItem.h"
#import "HBSidebarController.h"

@implementation UIViewController (HBSidebarControllerItem)

- (HBSidebarController *)sidebarController {
    UIViewController *parent = self.parentViewController;
    if ([parent isKindOfClass:[HBSidebarController class]]) {
        return (id)parent;
    }
    if (self.navigationController) {
        return [self.navigationController sidebarController];
    }
    return nil;
}

@end

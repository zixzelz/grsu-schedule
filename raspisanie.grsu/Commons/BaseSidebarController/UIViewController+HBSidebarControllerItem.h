//
//  UIViewController+HBSidebarControllerItem.h
//  HelpBook
//
//  Created by Ruslan Maslouski on 3/20/14.
//  Copyright (c) 2014 HelpBook Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBSidebarController;

@interface UIViewController (HBSidebarControllerItem)

- (HBSidebarController *)sidebarController;

@end

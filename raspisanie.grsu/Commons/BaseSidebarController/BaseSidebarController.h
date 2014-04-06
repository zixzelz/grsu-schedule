//
//  BaseSidebarController.h
//  HelpBook
//
//  Created by Ruslan Maslouski on 3/21/14.
//  Copyright (c) 2014 HelpBook Inc. All rights reserved.
//

#import "HBSidebarController.h"

@interface BaseSidebarController : HBSidebarController

- (UINavigationController *)navigationControllerForRoot:(UIViewController *)viewController;
- (void)setRootViewController:(UIViewController *)mainViewController animated:(BOOL)animated withNavigationController:(BOOL)navigationController;

@end

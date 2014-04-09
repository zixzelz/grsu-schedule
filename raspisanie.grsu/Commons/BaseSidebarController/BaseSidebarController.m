//
//  BaseSidebarController.m
//  HelpBook
//
//  Created by Ruslan Maslouski on 3/21/14.
//  Copyright (c) 2014 HelpBook Inc. All rights reserved.
//

#import "BaseSidebarController.h"

@interface BaseSidebarController () <HBSidebarDelegate>

@end


@implementation BaseSidebarController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (UINavigationController *)navigationControllerForRoot:(UIViewController *)viewController {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
//    [self setupNavigationItem:viewController.navigationItem];
    
    // styling
    navigationController.view.layer.masksToBounds = NO;
    navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    navigationController.view.layer.shadowOffset = CGSizeMake(0, 0);
    navigationController.view.layer.shadowOpacity = 0.2f;
    navigationController.view.layer.shadowRadius = 3.0f;
    
    CGRect pathRect = CGRectMake(CGRectGetWidth(navigationController.view.bounds) - 3, 0.0f, 6.0f, CGRectGetHeight(navigationController.view.bounds));
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:pathRect];
    [navigationController.view.layer setShadowPath:[path CGPath]];
    
    return navigationController;
}

- (void)setupNavigationItem:(UINavigationItem *)navigationItem {
    UIImage *imgLeft = [UIImage imageNamed:@"HBIcoSidebarMenu"];
    UIBarButtonItem* barButtonLeft = [[UIBarButtonItem alloc] initWithImage:imgLeft style:UIBarButtonItemStylePlain target:self action:@selector(leftSidebarButtonClicked:)];
    [navigationItem setLeftBarButtonItem:barButtonLeft];
}

- (void)leftSidebarButtonClicked:(id)sender {
    if (self.currentVisibleSubPage != SubPageTypeLeft) {
        [self showLeftViewControllerAnimated:YES];
    } else {
        [self hideCurrentViewControllerAnimated:YES];
    }
}

- (void)setUserInteractionForRoot:(BOOL)userInteractionEnabled {
    UIView *view;
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nc = (id)self.rootViewController;
        view = nc.topViewController.view;
    } else {
        view = self.rootViewController.view;
    }
    view.userInteractionEnabled = userInteractionEnabled;
}

#pragma mark - Overrive

- (void)setRootViewController:(UIViewController *)mainViewController animated:(BOOL)animated withNavigationController:(BOOL)navigationController {
    UIViewController *vc;
    if (navigationController) {
        vc = [self navigationControllerForRoot:mainViewController];
    } else {
        vc = mainViewController;
    }
    
    [super setRootViewController:vc animated:animated];
}

- (UIViewController *)visibleViewController {
    UIViewController *vc;
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        vc = [((UINavigationController *)self.rootViewController) visibleViewController];
    } else {
        vc = self.rootViewController;
    }
    return vc;
}

#pragma mark - HBSidebarDelegate

- (BOOL)sidebarController:(HBSidebarController *)sidebarController canInteractionShowSidebar:(SubPageType)subPageType {
    BOOL returnValue = YES;
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nc = (id)self.rootViewController;
        returnValue = nc.viewControllers.count == 1;
    }
    return returnValue;
}

- (void)sidebarController:(HBSidebarController *)sidebar willShowSidebar:(SubPageType)subPageType {
    [self setUserInteractionForRoot:NO];
}

- (void)sidebarController:(HBSidebarController *)sidebar didShowSidebar:(SubPageType)subPageType {
    self.leftViewController.view.userInteractionEnabled = YES;
}

- (void)sidebarController:(HBSidebarController *)sidebar willHideSidebar:(SubPageType)subPageType {
    self.leftViewController.view.userInteractionEnabled = NO;
}

- (void)sidebarController:(HBSidebarController *)sidebar didHideSidebar:(SubPageType)subPageType {
    [self setUserInteractionForRoot:YES];
}

@end

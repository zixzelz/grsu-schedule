//
//  HBSidebar.h
//  HelpBook
//
//  Created by Ruslan Maslouski on 2/5/14.
//  Copyright (c) 2013 Ruslan Maslouski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HBSidebarControllerItem.h"

@protocol HBSidebarDelegate;

typedef void(^CompletionBlock)();

typedef enum NSUInteger {
    SubPageTypeNone = 0,
    SubPageTypeLeft,
    SubPageTypeRight
} SubPageType;

@interface HBSidebarController : UIViewController

@property (nonatomic, weak) id<HBSidebarDelegate> delegate;

@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, assign) BOOL leftSwipeEnabled;
@property (nonatomic, assign) BOOL rightSwipeEnabled;
@property (nonatomic, assign) BOOL movementForMargin;

@property (nonatomic, strong) UIColor *backgroundColor;

- (id)initWithRootViewController:(UIViewController *)rootViewController;
- (void)setRootViewController:(UIViewController *)mainViewController animated:(BOOL)animated;

- (SubPageType)currentVisibleSubPage;
- (UIViewController *)currentVisibleViewController;
- (UIViewController *)rootViewController;

- (void)showLeftViewControllerAnimated:(BOOL)animated;
- (void)showRightViewControllerAnimated:(BOOL)animated;
- (void)showLeftViewControllerAnimated:(BOOL)animated completion:(CompletionBlock)completion;
- (void)showRightViewControllerAnimated:(BOOL)animated completion:(CompletionBlock)completion;

- (void)hideCurrentViewControllerAnimated:(BOOL)animated;
- (void)hideCurrentViewControllerAnimated:(BOOL)animated completion:(CompletionBlock)completion;

@end

@protocol HBSidebarDelegate <NSObject>

@optional

- (BOOL)sidebarController:(HBSidebarController *)sidebarController canInteractionShowSidebar:(SubPageType)subPageType;

- (void)sidebarController:(HBSidebarController *)sidebarController willShowSidebar:(SubPageType)subPageType;
- (void)sidebarController:(HBSidebarController *)sidebarController didShowSidebar:(SubPageType)subPageType;
- (void)sidebarController:(HBSidebarController *)sidebarController willHideSidebar:(SubPageType)subPageType;
- (void)sidebarController:(HBSidebarController *)sidebarController didHideSidebar:(SubPageType)subPageType;

@end
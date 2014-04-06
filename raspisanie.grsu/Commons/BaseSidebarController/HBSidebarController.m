//
//  HBSidebar.m
//  HelpBook
//
//  Created by Ruslan Maslouski on 2/5/14.
//  Copyright (c) 2013 Ruslan Maslouski. All rights reserved.
//

#import "HBSidebarController.h"

#define VELOCITY_TO_SWIPE 800
#define ROOT_POSITION_X self.rootViewController.view.frame.origin.x
#define DEFAULT_ANIMATION_DURATION 0.4f
#define DEFAULT_MARGIN_WIDTH_ROOT_VIEW 50.0f
#define DEFAULT_SWIPE_ENABLED YES
#define DEFAULT_MOVEMENT_FOR_MARGIN NO

#define ADHESION_WIDTH 8

#define MARGIN_FOR_REPLACE_VIEW -5.0f
#define ANIMATION_DURATION_FOR_REPLACE_VIEW 0.1f
#define ANIMATION_DURATION_FOR_CHANGE_MARGIN 0.1f

typedef void(^AnimationTransitionView)(UIView *fromView, UIView *toView, NSTimeInterval duration, CompletionBlock completion);


typedef NS_ENUM(NSInteger, Direction) {
    DirectionCenter = 0,
    DirectionLeft,
    DirectionRight
} Direction_;

typedef NS_OPTIONS(NSUInteger, AnimationType) {
    AnimationTypeEaseInOut = UIViewAnimationOptionCurveEaseInOut,
    AnimationTypeEaseIn = UIViewAnimationOptionCurveEaseIn,
    AnimationTypeEaseOut = UIViewAnimationOptionCurveEaseOut
} AnimationType_;

@interface HBSidebarController ()

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, assign) SubPageType oldVisiblePanSubPage;
@property (nonatomic, assign) SubPageType currentVisibleSubPage;

@end

@implementation HBSidebarController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [self init];
    if (self) {
        [self setRootViewController:rootViewController animated:NO];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentVisibleSubPage = SubPageTypeNone;
        self.oldVisiblePanSubPage = SubPageTypeNone;
        self.leftMargin = DEFAULT_MARGIN_WIDTH_ROOT_VIEW;
        self.rightMargin = DEFAULT_MARGIN_WIDTH_ROOT_VIEW;
        self.animationDuration = DEFAULT_ANIMATION_DURATION;
        self.leftSwipeEnabled = DEFAULT_SWIPE_ENABLED;
        self.rightSwipeEnabled = DEFAULT_SWIPE_ENABLED;
        self.movementForMargin = DEFAULT_MOVEMENT_FOR_MARGIN;
    }
    return self;
}

- (void)initPanGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(didPanGesture:)];
    pan.edges = UIRectEdgeLeft;
    [self.rootViewController.view addGestureRecognizer:pan];

    pan = [[UIScreenEdgePanGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(didPanGesture:)];
    pan.edges = UIRectEdgeRight;
    [self.rootViewController.view addGestureRecognizer:pan];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    NSLog(@"%@: %@", [self class], @"shouldAutorotateToInterfaceOrientation");
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self changeMarginForCurrentViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark Setters

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.view.backgroundColor = backgroundColor;
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    [self.leftViewController removeFromParentViewController];
    _leftViewController = leftViewController;
    if (leftViewController) {
        [self addChildViewController:leftViewController];
    }
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    [self.rightViewController removeFromParentViewController];
    _rightViewController = rightViewController;
    if (rightViewController) {
        [self addChildViewController:rightViewController];
    }
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    if(_leftMargin != leftMargin) {
        _leftMargin = leftMargin;
        [self changeMarginForCurrentViewControllerAnimated:YES];
    }
}

- (void)setRightMargin:(CGFloat)rightMargin {
    if(_rightMargin != rightMargin) {
        _rightMargin = rightMargin;
        [self changeMarginForCurrentViewControllerAnimated:YES];
    }
}

- (void)changeMarginForCurrentViewControllerAnimated:(BOOL)animated {
    SubPageType type = self.currentVisibleSubPage;
    if (type != SubPageTypeNone) {
        NSTimeInterval duration = ANIMATION_DURATION_FOR_CHANGE_MARGIN;
        if (!animated) {
            duration = 0.0f;
        }
        [self applyMarginForCurrentViewWithMargin:[self marginForType:type]
                                         duration:duration
                                       completion:nil];
    }
}

- (void)setRootViewController:(UIViewController *)rootViewController animated:(BOOL)animated {
    
    CompletionBlock replaceViewController = ^() {
        [self.rootViewController removeFromParentViewController];
        [self addChildViewController:rootViewController];
        self.rootViewController = rootViewController;
        [self initPanGestureRecognizer];
    };

    if (animated) {
        if (self.currentVisibleSubPage == SubPageTypeNone) {
            [self animationFlipTransitionFromView:self.rootViewController.view
                                           toView:rootViewController.view
                                       completion:replaceViewController];
        } else {
            [self animationPlainTransitionFromView:self.rootViewController.view
                                            toView:rootViewController.view
                                        completion:replaceViewController];
        }
    } else {
        [self.rootViewController.view removeFromSuperview];
        replaceViewController();
        [self.view addSubview:rootViewController.view];
    }
}

- (void)animationFlipTransitionFromView:(UIView *)fromView toView:(UIView *)toView completion:(CompletionBlock)completion {
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:self.animationDuration
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        completion();
                    }];
}

- (void)animationPlainTransitionFromView:(UIView *)fromView toView:(UIView *)toView completion:(CompletionBlock)completion {
    
    CompletionBlock replaceView = ^(void) {
        UIView *superView = fromView.superview;
        toView.frame = fromView.frame;
        
        [fromView removeFromSuperview];
        [superView addSubview:toView];
    };
    
    [self applyMarginForCurrentViewWithMargin:MARGIN_FOR_REPLACE_VIEW
                                     duration:ANIMATION_DURATION_FOR_REPLACE_VIEW
                                   completion:^{
                                       replaceView();
                                       completion();
                                       [self hideCurrentViewControllerAnimated:YES];
                                   }];
}

- (void)applyMarginForCurrentViewWithMargin:(CGFloat)margin duration:(NSTimeInterval)duration completion:(CompletionBlock)completion {
    Direction direction = [self animationDirectionForSubpageType:self.currentVisibleSubPage];
    [self plainAnimationWithRootView:self.rootViewController.view
                         subpageView:self.currentVisibleViewController.view
                 marginWidthRootView:margin
                            duration:duration
                           direction:direction
                       animationType:AnimationTypeEaseInOut
                          completion:^{
                              if (completion) {
                                  completion();
                              }
                          }];
}

#pragma mark -
#pragma mark Pan Gesture Recognizer

- (void)didPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        [self didBeganPanGesture:gestureRecognizer];
    } else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        [self didChangedPanGesture:gestureRecognizer];
    } else {
        [self didEndPanGesture:gestureRecognizer];
        self.oldVisiblePanSubPage = SubPageTypeNone;
    }
}

- (void)didBeganPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    self.oldVisiblePanSubPage = self.currentVisibleSubPage;
    
    if (self.currentVisibleSubPage != SubPageTypeNone && [self.delegate respondsToSelector:@selector(sidebarController:willHideSidebar:)]) {
        [self.delegate sidebarController:self willHideSidebar:self.currentVisibleSubPage];
    }
}

- (void)didChangedPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat translation = [gestureRecognizer translationInView:self.view].x;
    
    if (self.oldVisiblePanSubPage == SubPageTypeNone && ABS(translation) < ADHESION_WIDTH) {
        return;
    }

    SubPageType newType = [self typeViewControllerForPanModeWithTranslation:translation];

    BOOL canInteractionShowSidebar = YES;
    if ([self.delegate respondsToSelector:@selector(sidebarController:canInteractionShowSidebar:)]) {
        canInteractionShowSidebar = [self.delegate sidebarController:self canInteractionShowSidebar:newType];
    }
    
    if (![self isSwipeEnabledForType:newType] ||
        ![self viewControllerWithType:newType] ||
        !canInteractionShowSidebar ||
        (self.oldVisiblePanSubPage != SubPageTypeNone && self.oldVisiblePanSubPage != newType)) {
        CGRect frame = self.rootViewController.view.frame;
        frame.origin = CGPointZero;
        self.rootViewController.view.frame = frame;
        return;
    }
    
    if (self.oldVisiblePanSubPage != newType && [self.delegate respondsToSelector:@selector(sidebarController:willShowSidebar:)]) {
        [self.delegate sidebarController:self willShowSidebar:newType];
    }
    
    CGFloat sizeToMargin = self.view.frame.size.width - [self marginForType:newType];
    if (!self.movementForMargin && ABS(ROOT_POSITION_X + translation) > sizeToMargin) {
        CGRect frame = self.rootViewController.view.frame;
        if (self.oldVisiblePanSubPage == SubPageTypeLeft) {
            frame.origin.x = sizeToMargin;
        } else {
            frame.origin.x = - sizeToMargin;
        }
        self.rootViewController.view.frame = frame;
        return;
    }
    
    [self showViewControllerWithType:newType translation:translation];
    self.oldVisiblePanSubPage = newType;

    [gestureRecognizer setTranslation:CGPointZero inView:self.view];
}

- (void)didEndPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGFloat velocity = [gestureRecognizer velocityInView:self.view].x;
    SubPageType subpageType = self.oldVisiblePanSubPage;
    
    if (subpageType == SubPageTypeNone) {
        return;
    }
    
    // --== SWIPE ==--
    if (ABS(velocity) > VELOCITY_TO_SWIPE) {
        [self didSwipeWithVelocity:velocity];
        return;
    }
    
    if (ABS(ROOT_POSITION_X) > (self.view.frame.size.width / 2)) {
        [self showViewControllerWithType:subpageType animated:YES animationType:AnimationTypeEaseInOut duration:self.animationDuration completion:nil];
    } else {
        [self hideCurrentViewControllerAnimated:YES animationType:AnimationTypeEaseInOut duration:self.animationDuration completion:nil];
    }
}

- (void)didSwipeWithVelocity:(CGFloat)velocity {
    Direction directionSwipe = [self directionFromFloat:velocity];
    SubPageType subpageType = self.oldVisiblePanSubPage;
    if ((self.oldVisiblePanSubPage == SubPageTypeLeft && directionSwipe == DirectionRight) ||
        (self.oldVisiblePanSubPage == SubPageTypeRight && directionSwipe == DirectionLeft) ||
        (self.oldVisiblePanSubPage == SubPageTypeNone )) {
        CGFloat duration = (self.view.frame.size.width - [self marginForType:subpageType] - ABS(ROOT_POSITION_X)) / ABS(velocity);
        [self showViewControllerWithType:subpageType animated:YES animationType:AnimationTypeEaseOut duration:duration completion:nil];
    } else {
        CGFloat duration = ABS(ROOT_POSITION_X) / ABS(velocity);
        [self hideCurrentViewControllerAnimated:YES animationType:AnimationTypeEaseOut duration:duration completion:nil];
    }
}

#pragma mark -
#pragma mark Show Subpage

- (void)showLeftViewControllerAnimated:(BOOL)animated {
    [self showLeftViewControllerAnimated:animated completion:nil];
}

- (void)showLeftViewControllerAnimated:(BOOL)animated completion:(CompletionBlock)completion {
    if ([self.delegate respondsToSelector:@selector(sidebarController:willShowSidebar:)]) {
        [self.delegate sidebarController:self willShowSidebar:SubPageTypeLeft];
    }
    CGFloat duration = self.animationDuration;
    [self showViewControllerWithType:SubPageTypeLeft animated:animated animationType:AnimationTypeEaseInOut duration:duration completion:completion];
}

- (void)showRightViewControllerAnimated:(BOOL)animated {
    [self showRightViewControllerAnimated:animated completion:nil];
}

- (void)showRightViewControllerAnimated:(BOOL)animated completion:(CompletionBlock)completion {
    if ([self.delegate respondsToSelector:@selector(sidebarController:willShowSidebar:)]) {
        [self.delegate sidebarController:self willShowSidebar:SubPageTypeRight];
    }
    CGFloat duration = self.animationDuration;
    [self showViewControllerWithType:SubPageTypeRight animated:animated animationType:AnimationTypeEaseInOut duration:duration completion:completion];
}

- (void)showViewControllerWithType:(SubPageType)type animated:(BOOL)animated animationType:(AnimationType)animationType duration:(CGFloat)duration completion:(CompletionBlock)completion {
    
    // replace subpage
    if (self.currentVisibleSubPage != SubPageTypeNone && self.currentVisibleSubPage != type) {
        
        CompletionBlock showVC = ^(void) {
            [self showViewControllerWithType:type
                                    animated:animated
                               animationType:AnimationTypeEaseOut
                                    duration:duration
                                  completion:completion];
        };
        
        [self hideCurrentViewControllerAnimated:YES
                                  animationType:AnimationTypeEaseIn
                                       duration:duration
                                     completion:showVC];
        return;
    }
    
    UIViewController *subViewController = [self viewControllerWithType:type];
    if (!subViewController) {
        return;
    }
    
    if (!animated) {
        duration = 0;
    }
    
    [self addViewWithType:type animated:animated];
    
    [self plainAnimationWithRootView:self.rootViewController.view
                         subpageView:subViewController.view
                 marginWidthRootView:[self marginForType:type]
                            duration:duration
                           direction:[self animationDirectionForSubpageType:type]
                       animationType:animationType
                          completion:^{
                              if ([self.delegate respondsToSelector:@selector(sidebarController:didShowSidebar:)]) {
                                  [self.delegate sidebarController:self didShowSidebar:type];
                              }

                              if (self.currentVisibleSubPage == SubPageTypeNone) {
                                  [subViewController endAppearanceTransition];
                                  self.currentVisibleSubPage = type;
                              }
                              if (completion) {
                                  completion();
                              }
                          }];
}

- (void)showViewControllerWithType:(SubPageType)type translation:(CGFloat)translation {
    UIViewController *viewController = [self viewControllerWithType:type];
    if (!viewController) {
        return;
    }
    
    [self addViewWithType:type animated:NO];
    
    [self performPanShowWithMainView:self.rootViewController.view
                                        subPageView:viewController.view
                                        translation:translation];
}

- (void)addViewWithType:(SubPageType)type animated:(BOOL)animated {
    UIViewController *subViewController = [self viewControllerWithType:type];
    if (!subViewController.view.superview) {
        [subViewController beginAppearanceTransition:YES animated:animated];
        
        // change size
        CGRect frame = subViewController.view.frame;
//        CGFloat margin = [self marginForType:type];
        
//        if (type == SubPageTypeRight) {
//            frame.origin.x = margin;
//        }
        
        frame.size = self.view.bounds.size;
//        frame.size.width -= margin;
        subViewController.view.frame = frame;
        
        [self.view insertSubview:subViewController.view belowSubview:self.rootViewController.view];
        //[subViewController.view setNeedsLayout];
    }
}

#pragma mark -
#pragma mark hide Page

- (void)hideCurrentViewControllerAnimated:(BOOL)animated {
    [self hideCurrentViewControllerAnimated:animated completion:nil];
}

- (void)hideCurrentViewControllerAnimated:(BOOL)animated completion:(CompletionBlock)completion {
    if ([self.delegate respondsToSelector:@selector(sidebarController:willHideSidebar:)]) {
        [self.delegate sidebarController:self willHideSidebar:self.currentVisibleSubPage];
    }

    CGFloat duration = self.animationDuration;
    [self hideCurrentViewControllerAnimated:animated animationType:AnimationTypeEaseInOut duration:duration completion:completion];
}

- (void)hideCurrentViewControllerAnimated:(BOOL)animated animationType:(AnimationType)animationType duration:(CGFloat)duration completion:(CompletionBlock)completion {
    if (!animated) {
        duration = 0;
    }
    
    UIViewController *viewController = [self currentVisibleViewController];
    if (!viewController) {
        viewController = [self viewControllerWithType:self.oldVisiblePanSubPage];
        self.oldVisiblePanSubPage = SubPageTypeNone;
    }

    [viewController beginAppearanceTransition:NO animated:animated];
    [self plainAnimationWithRootView:self.rootViewController.view
                         subpageView:viewController.view
                 marginWidthRootView:0.0f
                            duration:duration
                           direction:DirectionCenter
                       animationType:animationType
                          completion:^{
                              [viewController.view removeFromSuperview];
                              [viewController endAppearanceTransition];

                              if ([self.delegate respondsToSelector:@selector(sidebarController:didHideSidebar:)]) {
                                  [self.delegate sidebarController:self didHideSidebar:self.currentVisibleSubPage];
                              }

                              self.currentVisibleSubPage = SubPageTypeNone;
                              self.oldVisiblePanSubPage = SubPageTypeNone;
                              if (completion) {
                                  completion();
                              }
                          }];
}

#pragma mark -
#pragma mark Animation

- (void)plainAnimationWithRootView:(UIView *)rootView subpageView:(UIView *)subpageView marginWidthRootView:(CGFloat)margin duration:(NSTimeInterval)duration direction:(Direction)direction animationType:(AnimationType)animationType completion:(CompletionBlock)completion  {
    
    CompletionBlock newFrameToView = ^(void) {
        CGRect frame = rootView.frame;
        CGFloat newPosition;
        switch (direction) {
            case DirectionCenter:
                newPosition = 0;
                break;
            case DirectionLeft:
                newPosition = -(frame.size.width - margin);
                break;
            case DirectionRight:
                newPosition = frame.size.width - margin;
                break;
        }
        frame.origin.x = newPosition;
        rootView.frame = frame;
    };

    if (duration > 0) {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:(UIViewAnimationOptions)animationType
                         animations:newFrameToView
                         completion:^(BOOL finished) {
                             if (completion) {
                                 completion();
                             }
                         }];
    } else {
        newFrameToView();
        if (completion) {
            completion();
        }
    }
}

- (void)performPanShowWithMainView:(UIView *)mainView subPageView:(UIView *)subPageView translation:(CGFloat)translation {
    CGRect frame = mainView.frame;
    frame.origin.x += translation;
    mainView.frame = frame;
}

#pragma mark -
#pragma mark Utils

- (CGFloat)marginForType:(SubPageType)type {
    CGFloat margin = 0.0f;
    if (type == SubPageTypeLeft) {
        margin = self.leftMargin;
    } else if (type == SubPageTypeRight) {
        margin = self.rightMargin;
    }
    return margin;
}

- (BOOL)isSwipeEnabledForType:(SubPageType)type {
    BOOL returnValue;
    switch (type) {
        case SubPageTypeLeft:
            returnValue = self.leftSwipeEnabled;
            break;
        case SubPageTypeRight:
            returnValue = self.rightSwipeEnabled;
            break;
        case SubPageTypeNone:
            returnValue = NO;
            break;
    }
    return returnValue;
}

- (Direction)directionFromFloat:(CGFloat)value {
    Direction direction = DirectionCenter;
    if (value > 0) {
        direction = DirectionRight;
    } else if (value < 0) {
        direction = DirectionLeft;
    }
    return direction;
}

- (Direction)animationDirectionForSubpageType:(SubPageType)type {
    Direction direction = DirectionCenter;
    if (type == SubPageTypeLeft) {
        direction = DirectionRight;
    } else if (type == SubPageTypeRight) {
        direction = DirectionLeft;
    }
    return direction;
}

- (SubPageType)typeViewControllerForPanModeWithTranslation:(CGFloat)translation {
    CGFloat newPositionX = ROOT_POSITION_X + translation;
    return [self typeViewControllerWithFloat:newPositionX];
}

- (SubPageType)typeViewControllerWithFloat:(CGFloat)value {
    SubPageType subpageType = SubPageTypeNone;
    if (value > 0) {
        subpageType = SubPageTypeLeft;
    } else if (value < 0) {
        subpageType = SubPageTypeRight;
    }
    return subpageType;
}

- (UIViewController *)currentVisibleViewController {
    return [self viewControllerWithType:self.currentVisibleSubPage];
}

- (UIViewController *)viewControllerWithType:(SubPageType)type {
    UIViewController *viewController = nil;
    switch (type) {
        case SubPageTypeLeft:
            viewController = self.leftViewController;
            break;
        case SubPageTypeRight:
            viewController = self.rightViewController;
            break;
        case SubPageTypeNone:
            viewController = nil;
            break;
    }
    return viewController;
}

@end

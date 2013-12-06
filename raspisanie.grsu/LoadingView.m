//
//  LoadingView.m
//  OnlinerRSS
//
//  Created by Ruslan Maslouski on 10/15/12.
//  Copyright (c) 2012 Ruslan Maslouski. All rights reserved.
//

#import "LoadingView.h"
#import "QuartzCore/QuartzCore.h"

#define INTERVAL_ANIMATIONS 0.5

@implementation LoadingView

- (id)initWithView:(UIView *)view {
    self = [super initWithFrame:view.frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.1f];
        [self addSpinner];
        [view addSubview:self];
        self.hidden = YES;
    }
    return self;
}

- (void)addSpinner {
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] init];
    spinner.layer.cornerRadius = 10.0f;
    spinner.frame = CGRectMake(0, 0, 80, 80);
    spinner.center = self.center;
    spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
    spinner.color = [UIColor whiteColor];
    spinner.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    [spinner startAnimating];
    [self addSubview:spinner];
    [spinner release];
}

- (void)showLoading {
    [self showLoadingWithUserInteraction:YES];
}

- (void)showLoadingWithUserInteraction:(BOOL)userInteractionEnabled {
    self.hidden = NO;
    self.userInteractionEnabled = userInteractionEnabled;
    self.alpha = 1.0f;
}

- (void)hideLoading {
    [self hideLoadingWithCompletion:nil];
}

- (void)hideLoadingWithCompletion:(void (^)(BOOL finished))completion {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:INTERVAL_ANIMATIONS
                     animations:^{ self.alpha = 0.0f; }
                     completion:completion];
}

@end

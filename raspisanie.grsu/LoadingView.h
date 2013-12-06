//
//  LoadingView.h
//  OnlinerRSS
//
//  Created by Ruslan Maslouski on 10/15/12.
//  Copyright (c) 2012 Ruslan Maslouski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

- (id)initWithView:(UIView *)view;

- (void)showLoading;
- (void)showLoadingWithUserInteraction:(BOOL)userInteractionEnabled;
- (void)hideLoading;
- (void)hideLoadingWithCompletion:(void (^)(BOOL finished))completion;

@end

//
//  NSString+Expanded.h
//  HelpBook
//
//  Created by Ruslan Maslouski on 8/23/13.
//  Copyright (c) 2013 HelpBook Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Expanded)

+ (BOOL) isNilOrEmpty:(NSString*)str;

NSString *NSStringFromCGFloat(CGFloat value);

@end

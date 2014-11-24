//
//  NSString+Expanded.h
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 8/23/13.
//  Copyright (c) 2013 Ruslan Maslouski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Expanded)

+ (BOOL)isNilOrEmpty:(NSString *)str;
+ (NSString *)emptyString;

NSString *ReplaceNilToEmptyString(NSString *value);

@end

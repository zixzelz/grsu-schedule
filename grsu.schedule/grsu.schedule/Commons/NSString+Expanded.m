//
//  NSString+Expanded.m
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 8/23/13.
//  Copyright (c) 2013 Ruslan Maslouski. All rights reserved.
//

#import "NSString+Expanded.h"

@implementation NSString (Expanded)

+ (BOOL) isNilOrEmpty:(NSString*)str {
	if(str == nil)
		return YES;
    if (str == (id)[NSNull null]) {
        return YES;
    }
	if([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1)
		return YES;
	if([str isEqualToString:@"(null)"] || [str isEqualToString:@"null"])
		return YES;
	return NO;
}

+ (NSString *)emptyString {
    return @"";
}

NSString *ReplaceNilToEmptyString(NSString *value) {
    return value ? value : @"";
}

@end

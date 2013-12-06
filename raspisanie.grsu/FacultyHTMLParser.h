//
//  FacultyHTMLParser.h
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacultyHTMLParser : NSObject

+ (NSArray *)parseWithHTML:(NSString *)html key:(NSString *)key;
+ (NSArray *)scheduleParseWithHTML:(NSString *)html;
+ (void)stateParseWithHTML:(NSString *)html viewState:(NSString **)viewState eventValidation:(NSString **)eventValidation;

@end

//
//  LessonScheduleParse.h
//  raspisanie.grsu
//
//  Created by Ruslan on 08.12.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonScheduleParse : NSObject

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) NSString *disc;
@property (nonatomic, strong) NSString *aud;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *teacher;

@end

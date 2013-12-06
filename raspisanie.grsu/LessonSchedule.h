//
//  LessonSchedule.h
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonSchedule : NSObject

@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) NSString *disc;
@property (nonatomic, strong) NSString *aud;
@property (nonatomic, strong) NSString *teacher;

@end

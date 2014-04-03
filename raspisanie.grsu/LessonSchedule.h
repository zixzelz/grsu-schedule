//
//  LessonSchedule.h
//  raspisanie.grsu
//
//  Created by Ruslan on 08.12.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DaySchedule;

@interface LessonSchedule : NSManagedObject

@property (nonatomic, retain) NSString * groupTitle;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * room;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * stopTime;
@property (nonatomic, retain) NSString * studyName;
@property (nonatomic, retain) NSString * teacher;
@property (nonatomic, retain) DaySchedule *daySchedule;

@end

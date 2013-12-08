//
//  DaySchedule.h
//  raspisanie.grsu
//
//  Created by Ruslan on 08.12.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LessonSchedule, Week;

@interface DaySchedule : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Week *week;
@property (nonatomic, retain) NSSet *lessons;
@end

@interface DaySchedule (CoreDataGeneratedAccessors)

- (void)addLessonsObject:(LessonSchedule *)value;
- (void)removeLessonsObject:(LessonSchedule *)value;
- (void)addLessons:(NSSet *)values;
- (void)removeLessons:(NSSet *)values;

@end

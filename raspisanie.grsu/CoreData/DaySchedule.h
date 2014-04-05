//
//  DaySchedule.h
//  raspisanie.grsu
//
//  Created by Ruslan on 03.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LessonSchedule, Week;

@interface DaySchedule : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSOrderedSet *lessons;
@property (nonatomic, retain) Week *week;
@end

@interface DaySchedule (CoreDataGeneratedAccessors)

- (void)insertObject:(LessonSchedule *)value inLessonsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLessonsAtIndex:(NSUInteger)idx;
- (void)insertLessons:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLessonsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLessonsAtIndex:(NSUInteger)idx withObject:(LessonSchedule *)value;
- (void)replaceLessonsAtIndexes:(NSIndexSet *)indexes withLessons:(NSArray *)values;
- (void)addLessonsObject:(LessonSchedule *)value;
- (void)removeLessonsObject:(LessonSchedule *)value;
- (void)addLessons:(NSOrderedSet *)values;
- (void)removeLessons:(NSOrderedSet *)values;
@end

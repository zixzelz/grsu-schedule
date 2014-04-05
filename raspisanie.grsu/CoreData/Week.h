//
//  Week.h
//  raspisanie.grsu
//
//  Created by Ruslan on 05.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DaySchedule, Group;

@interface Week : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * title;
@property (nonatomic, retain) Group *group;
@property (nonatomic, retain) NSOrderedSet *dayschedule;
@end

@interface Week (CoreDataGeneratedAccessors)

- (void)insertObject:(DaySchedule *)value inDayscheduleAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDayscheduleAtIndex:(NSUInteger)idx;
- (void)insertDayschedule:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDayscheduleAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDayscheduleAtIndex:(NSUInteger)idx withObject:(DaySchedule *)value;
- (void)replaceDayscheduleAtIndexes:(NSIndexSet *)indexes withDayschedule:(NSArray *)values;
- (void)addDayscheduleObject:(DaySchedule *)value;
- (void)removeDayscheduleObject:(DaySchedule *)value;
- (void)addDayschedule:(NSOrderedSet *)values;
- (void)removeDayschedule:(NSOrderedSet *)values;
@end
 
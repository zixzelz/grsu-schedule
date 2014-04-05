//
//  Group.h
//  raspisanie.grsu
//
//  Created by Ruslan on 05.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Week;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) NSSet *week;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addWeekObject:(Week *)value;
- (void)removeWeekObject:(Week *)value;
- (void)addWeek:(NSSet *)values;
- (void)removeWeek:(NSSet *)values;

@end

//
//  Course.h
//  raspisanie.grsu
//
//  Created by Ruslan on 05.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group, Specialization;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Specialization *specialization;
@property (nonatomic, retain) NSSet *group;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addGroupObject:(Group *)value;
- (void)removeGroupObject:(Group *)value;
- (void)addGroup:(NSSet *)values;
- (void)removeGroup:(NSSet *)values;

@end

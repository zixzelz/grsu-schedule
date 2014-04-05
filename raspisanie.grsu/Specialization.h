//
//  Specialization.h
//  raspisanie.grsu
//
//  Created by Ruslan on 05.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, Faculty;

@interface Specialization : NSManagedObject

@property (nonatomic, retain) NSString * facultyID;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Faculty *faculty;
@property (nonatomic, retain) NSSet *course;
@end

@interface Specialization (CoreDataGeneratedAccessors)

- (void)addCourseObject:(Course *)value;
- (void)removeCourseObject:(Course *)value;
- (void)addCourse:(NSSet *)values;
- (void)removeCourse:(NSSet *)values;

@end

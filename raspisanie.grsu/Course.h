//
//  Course.h
//  raspisanie.grsu
//
//  Created by Ruslan on 07.12.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Specialization;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Specialization *specialization;

@end

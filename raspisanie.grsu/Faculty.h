//
//  Faculty.h
//  raspisanie.grsu
//
//  Created by Ruslan on 05.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Specialization;

@interface Faculty : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Specialization *specialization;

@end

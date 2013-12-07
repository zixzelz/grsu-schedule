//
//  DaySchedule.h
//  raspisanie.grsu
//
//  Created by Ruslan on 07.12.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Week;

@interface DaySchedule : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Week *week;

@end

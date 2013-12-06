//
//  ReqState.h
//  raspisanie.grsu
//
//  Created by Ruslan on 03.11.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReqState : NSManagedObject

@property (nonatomic, retain) NSString * facultyID;
@property (nonatomic, retain) NSString * specializationID;
@property (nonatomic, retain) NSString * courseID;
@property (nonatomic, retain) NSString * groupID;
@property (nonatomic, retain) NSString * weekID;
@property (nonatomic, retain) NSString * viewState;
@property (nonatomic, retain) NSString * eventValidation;

@end

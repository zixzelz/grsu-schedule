//
//  FacultyItem.h
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacultyItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *id;

+ (FacultyItem *)faculityItemWithId:(NSString *)id_ title:(NSString *)title;

@end

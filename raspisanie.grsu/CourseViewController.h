//
//  CourseViewController.h
//  raspisanie.grsu
//
//  Created by Ruslan on 17.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacultyItem.h"

@interface CourseViewController : UIViewController

- (id)initWithFacultyItem:(FacultyItem *)facultyItem specializationItem:(FacultyItem *)specializationItem;

@end

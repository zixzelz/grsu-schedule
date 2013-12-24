//
//  LessonScheduleCell.h
//  raspisanie.grsu
//
//  Created by Ruslan on 19.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonScheduleCell : UITableViewCell

@property (nonatomic, weak, readonly) UILabel* location;
@property (nonatomic, weak, readonly) UILabel* startTime;
@property (nonatomic, weak, readonly) UILabel* stopTime;
@property (nonatomic, weak, readonly) UILabel* studyName;
@property (nonatomic, weak, readonly) UILabel* teacher;

+ (CGFloat)heightForSmallCellWithText:(NSString *)text tableWidth:(CGFloat)tableWidth;

@end

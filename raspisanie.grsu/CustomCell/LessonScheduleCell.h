//
//  LessonScheduleCell.h
//  raspisanie.grsu
//
//  Created by Ruslan on 19.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonScheduleCell : UITableViewCell

@property (nonatomic, weak, readonly) UILabel *locationLabel;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *stopTime;
@property (nonatomic, weak, readonly) UILabel *studyNameLabel;
@property (nonatomic, weak, readonly) UILabel *teacherLabel;

+ (CGFloat)heightForSmallCellWithText:(NSString *)text tableWidth:(CGFloat)tableWidth;

@end

//
//  LessonScheduleCell.m
//  raspisanie.grsu
//
//  Created by Ruslan on 19.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "LessonScheduleCell.h"
#import "DateUtils.h"

#define CELL_FONT_NAME @"Helvetica"
#define CELL_FONT_SIZE 17

#define SMALL_CELL_DEAFAUL_HEIGHT 86.0f
#define SMALL_CELL_TEXT_TOP_LOWER_FIELD 66.0f
#define SMALL_CELL_TEXT_LEFT_RIGHT_FIELD 99.0f

@interface LessonScheduleCell ()

@property (nonatomic, weak) IBOutlet UILabel* locationLabel;
@property (nonatomic, weak) IBOutlet UILabel* startTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* stopTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel* studyNameLabel;
@property (nonatomic, weak) IBOutlet UILabel* teacherLabel;

@end

@implementation LessonScheduleCell

- (void)setStartTime:(NSDate *)startTime {
    if (_startTime != startTime) {
        _startTime = startTime;
        self.startTimeLabel.text = [DateUtils formatDate:startTime withFormat:DateFormatTimeOnly];
    }
}

- (void)setStopTime:(NSDate *)stopTime {
    if (_stopTime != stopTime) {
        _stopTime = stopTime;
        self.stopTimeLabel.text = [DateUtils formatDate:stopTime withFormat:DateFormatTimeOnly];
    }
}

+ (CGFloat)heightForSmallCellWithText:(NSString *)text tableWidth:(CGFloat)tableWidth {
    CGFloat cellHeight;
    CGFloat labelHeight = [self heightWithString:text constrainedToWidth:tableWidth - SMALL_CELL_TEXT_LEFT_RIGHT_FIELD];
    cellHeight = MAX(labelHeight + SMALL_CELL_TEXT_TOP_LOWER_FIELD, SMALL_CELL_DEAFAUL_HEIGHT);
    return cellHeight;
}

+ (CGFloat)heightWithString:(NSString *)string constrainedToWidth:(CGFloat)constrainedToWidth {
    UIFont *cellFont = [UIFont fontWithName:CELL_FONT_NAME size:CELL_FONT_SIZE];
    CGSize constraintSize = CGSizeMake(constrainedToWidth, MAXFLOAT);
    CGRect textRect = [string boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    return CGRectGetHeight(textRect);
}

@end

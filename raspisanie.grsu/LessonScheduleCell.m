//
//  LessonScheduleCell.m
//  raspisanie.grsu
//
//  Created by Ruslan on 19.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "LessonScheduleCell.h"

#define CELL_FONT_NAME @"Helvetica"
#define CELL_FONT_SIZE 17

#define SMALL_CELL_DEAFAUL_HEIGHT 50.0f
#define SMALL_CELL_TEXT_TOP_LOWER_FIELD 26.0f
#define SMALL_CELL_TEXT_LEFT_RIGHT_FIELD 20 * 2

@interface LessonScheduleCell ()

@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *audLabel;
@property (nonatomic, strong) IBOutlet UILabel *discLabel;

@end

@implementation LessonScheduleCell

- (void)setTimeText:(NSString *)text {
    self.timeLabel.text = text;
}

- (void)setAudText:(NSString *)text {
    self.audLabel.text = text;
}

- (void)setDiscText:(NSString *)text {
    self.discLabel.text = text;
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
    CGSize labelSize = [string sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height;
}

@end

//
//  LessonScheduleCell.h
//  raspisanie.grsu
//
//  Created by Ruslan on 19.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LessonScheduleCell : UITableViewCell

- (void)setTimeText:(NSString *)text;
- (void)setAudText:(NSString *)text;
- (void)setDiscText:(NSString *)text;

+ (CGFloat)heightForSmallCellWithText:(NSString *)text tableWidth:(CGFloat)tableWidth;

@end

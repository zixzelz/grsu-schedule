//
//  ActiveLessonScheduleCell.m
//  raspisanie.grsu
//
//  Created by Ruslan on 05.04.14.
//  Copyright (c) 2014 RYSoft. All rights reserved.
//

#import "ActiveLessonScheduleCell.h"

@interface ActiveLessonScheduleCell ()

@property (nonatomic, weak) IBOutlet UIProgressView *lessonProgressView;

@end

@implementation ActiveLessonScheduleCell

- (void)updateLessonProgress {
    CGFloat start = [self.startTime timeIntervalSinceReferenceDate];
    CGFloat stop = [self.stopTime timeIntervalSinceReferenceDate];
    CGFloat now = [NSDate timeIntervalSinceReferenceDate] - start;
    CGFloat value = now / (stop - start);
    self.lessonProgressView.progress = value;
}

@end

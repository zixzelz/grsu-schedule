//
//  FacultyHTMLParser.m
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "FacultyHTMLParser.h"
#import "HTMLParser.h"
#import "ScheduleItem.h"
#import "DayScheduleParse.h"
#import "LessonScheduleParse.h"

@implementation FacultyHTMLParser

+ (NSArray *)parseWithHTML:(NSString *)html key:(NSString *)key {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
	HTMLNode * bodyNode = [parser body];
	HTMLNode * selectNode = [bodyNode findChildWithAttribute:@"name" matchingName:key allowPartial:YES];
    
    NSArray *optionNodes = [selectNode findChildTags:@"option"];
    NSMutableArray *facultyItems = [NSMutableArray arrayWithCapacity:optionNodes.count];
    for (HTMLNode *optionNode in optionNodes) {
        ScheduleItem *item = [ScheduleItem faculityItemWithId:[optionNode getAttributeNamed:@"value"]
                                                      title:[optionNode contents]];
        
        [facultyItems addObject:item];
    }
    return facultyItems;
}

+ (NSArray *)scheduleParseWithHTML:(NSString *)html {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
	HTMLNode * bodyNode = [parser body];
	HTMLNode * tableNode = [bodyNode findChildWithAttribute:@"class" matchingName:@"ch_table" allowPartial:YES];
    NSArray *trNodes = [tableNode findChildTags:@"tr"];
    
    NSMutableArray *days = [NSMutableArray array];
    NSMutableArray *lessons = [NSMutableArray array];
    DayScheduleParse *thisDay = [[DayScheduleParse alloc] init];
    for (HTMLNode *trNode in trNodes) {
        NSString *trClass = [trNode getAttributeNamed:@"class"];
        
        if ([trClass isEqualToString:@"ch_tr_odd"] || [trClass isEqualToString:@"ch_tr_nodd"]) {
            NSArray *tdNodes = [trNode findChildTags:@"td"];
            
            int i = 0;
            if (lessons.count == 0) {
                NSArray *day = [tdNodes[i++] children];
                thisDay.title = [day[0] allContents];
                thisDay.date  = [day[3] allContents];
            }
            LessonScheduleParse *lesson = [[LessonScheduleParse alloc] init];
            lesson.time     = [tdNodes[i++] contents];
            lesson.group    = [tdNodes[i++] contents];
            lesson.disc     = [self allContentWithNode:tdNodes[i++]];
            lesson.aud      = [tdNodes[i++] contents];
            lesson.teacher  = [tdNodes[i++] contents];
                        
            [lessons addObject:lesson];
        }
        
        if ([trClass isEqualToString:@"ch_tr_free"]) {
            thisDay.lessons = [NSArray arrayWithArray:lessons];
            [days addObject:thisDay];
            
            lessons = [NSMutableArray array];
            thisDay = [[DayScheduleParse alloc] init];
        }
    }
    return [NSArray arrayWithArray:days];
}

+ (void)stateParseWithHTML:(NSString *)html viewState:(NSString **)viewState eventValidation:(NSString **)eventValidation {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
	HTMLNode *bodyNode = [parser body];
	HTMLNode *viewStateNode = [bodyNode findChildWithAttribute:@"name" matchingName:@"__VIEWSTATE" allowPartial:YES];
	HTMLNode *eventValidationNode = [bodyNode findChildWithAttribute:@"name" matchingName:@"__EVENTVALIDATION" allowPartial:YES];
    *viewState = [viewStateNode getAttributeNamed:@"value"];
    *eventValidation = [eventValidationNode getAttributeNamed:@"value"];
}

+ (NSString *)allContentWithNode:(HTMLNode *)node {
    NSMutableString *string = [NSMutableString string];
    for (HTMLNode *nod in node.children) {
        if (string.length > 0) {
            [string appendString:@" "];
        }
        [string appendString:nod.allContents];
    }
    return [NSString stringWithString:string];
}

@end















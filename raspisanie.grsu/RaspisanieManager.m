//
//  RaspisanieManager.m
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "RaspisanieManager.h"
#import "Backend.h"
#import "CacheManager.h"

@interface RaspisanieManager () <UIWebViewDelegate>

@end

@implementation RaspisanieManager

#pragma mark Singelton methods

static RaspisanieManager *_instance;

+ (void)initialize {
    @synchronized(self) {
        if( _instance == nil ) {
            _instance = [[self alloc] init];
        }
    }
}

+ (RaspisanieManager *)sharedInstance {
    return _instance;
}

#pragma mark -

- (void)facultyItemsWithCallback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadFacultyItemsWithCallback:callback];
//    [[CacheManager sharedInstance] facultyItemsWithCallback:^(NSArray *array, NSError *error) {
//        if (array.count > 0) {
//            callback(array, error);
//        } else {
//            [[Backend sharedInstance] loadFacultyItemsWithCallback:callback];
//        }
//    }];
}

- (void)specializationItemsWithFacultyID:(NSString *)facultyID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadSpecializationItemsWithFacultyID:facultyID callback:callback];
}

- (void)courseItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadCourseItemsWithFacultyID:facultyID specializationID:specializationID callback:callback];
//    [self performRequestWithFacultyID:facultyID specializationID:specializationID courseID:nil groupID:nil weekID:nil callback:^(NSString *html, NSError *error) {
//        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_COURSE];
//        callback(array, error);
//    }];
}

- (void)groupItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadGroupItemsWithFacultyID:facultyID specializationID:specializationID courseID:courseID callback:callback];
//    [self performRequestWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:nil weekID:nil callback:^(NSString *html, NSError *error) {
//        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_GROUP];
//        callback(array, error);
//    }];
}

- (void)weekItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadWeekItemsWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID callback:callback];
//    [self performRequestWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:nil callback:^(NSString *html, NSError *error) {
//        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_WEEK];
//        callback(array, error);
//    }];
}

- (void)scheduleWeekWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID callback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadScheduleWeekWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:weekID callback:callback];
//    [self performRequestWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:weekID callback:^(NSString *html, NSError *error) {
//        NSArray *array = [FacultyHTMLParser scheduleParseWithHTML:html];
//        callback(array, error);
//    }];
}

@end


//- (void)facultyItemsWithCallback:(ArrayBlock)callback {
//    NSURL *url = [NSURL URLWithString:URL_RASPISANIE];
//    NSURLRequest *theRequest=[NSURLRequest requestWithURL:url
//                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                          timeoutInterval:URL_REQUEST_TIMEOUT];
//    
//    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"Connection failed, error: %@", error);
//        }
//        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        self.lastPOSTItem = [FacultyHTMLParser parsePOSTWithHTML:html];
//        NSArray *array = [FacultyHTMLParser parseWithHTML:html];
//        callback(array, error);
//    }];
//}
//
//- (void)specializationItemsWithFacultyID:(NSUInteger)facultyID Callback:(ArrayBlock)callback {
//    NSURL *url = [NSURL URLWithString:URL_RASPISANIE];
//    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url
//                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
//                                                        timeoutInterval:URL_REQUEST_TIMEOUT];
//    
//    [theRequest setHTTPMethod:@"POST"];
//    
//    NSString *someString = [NSString stringWithFormat:@"%@&lbFaculty=20", self.lastPOSTItem.post];
//    [theRequest setHTTPBody:[someString dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        if (error) {
//            NSLog(@"Connection failed, error: %@", error);
//        }
//        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSArray *array = [FacultyHTMLParser parseWithHTML:html];
//        callback(array, error);
//    }];
//}

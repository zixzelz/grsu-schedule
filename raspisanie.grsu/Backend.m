//
//  Backend.m
//  raspisanie.grsu
//
//  Created by Ruslan on 25.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "Backend.h"
#import "FacultyHTMLParser.h"
#import "CacheManager.h"

//#define URL_RASPISANIE @"http://raspisanie.grsu.by/TimeTable/UMU.aspx"
#define URL_RASPISANIE @"http://data.mf.grsu.by/TimeTable/ZaochnikiSchedule1.aspx"

#define SELECT_OPTION_SCRIPT1 @" \
$obj = document.getElementById(\"%@\"); \
for (var i = 0; i <= $obj.options.length - 1; i++) { \
if ($obj.options[i].value == \"%d\") { \
$obj.selectedIndex = i; \
break; \
} \
}"

#define SELECT_OPTION_SCRIPT @" \
$obj = document.getElementById(\"%@\"); \
$obj.options.length=1; \
$obj.options[0].value = \"%@\"; \
$obj.selectedIndex = 0; "

#define KEY_SELECT_FACULTY @"lbFaculty"
#define KEY_SELECT_SPECIALIZATION @"lbSpecialization"
#define KEY_SELECT_COURSE @"lbCourse"
#define KEY_SELECT_GROUP @"lbGroup"
#define KEY_SELECT_WEEK @"lbWeek"

typedef void (^DidFinishLoad)(NSString *html, NSError *error);

@interface Backend ()

@property (nonatomic, strong) NSString *viewState;
@property (nonatomic, strong) NSString *eventValidation;

@end

@implementation Backend

#pragma mark Singelton methods

static Backend *_instance;

+ (void)initialize {
    @synchronized(self) {
        if( _instance == nil ) {
            _instance = [[self alloc] init];
        }
    }
}

+ (Backend *)sharedInstance {
    return _instance;
}

#pragma mark -

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)loadFacultyItemsWithCallback:(ArrayBlock)callback {
    NSDictionary *params = [self dictionaryWithFacultyID:nil specializationID:nil courseID:nil groupID:nil weekID:nil];
    [self performRequestWithParams:params callback:^(NSString *html, NSError *error) {
        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_FACULTY];
        callback(array, error);
    }];
}

- (void)loadSpecializationItemsWithFacultyID:(NSString *)facultyID callback:(ArrayBlock)callback {
    NSDictionary *params = [self dictionaryWithFacultyID:facultyID specializationID:nil courseID:nil groupID:nil weekID:nil];
    [self performRequestWithParams:params callback:^(NSString *html, NSError *error) {
        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_SPECIALIZATION];
        callback(array, error);
    }];
}

- (void)loadCourseItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID callback:(ArrayBlock)callback {
    NSDictionary *params = [self dictionaryWithFacultyID:facultyID specializationID:specializationID courseID:nil groupID:nil weekID:nil];
    [self performRequestWithParams:params callback:^(NSString *html, NSError *error) {
        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_COURSE];
        callback(array, error);
    }];
}

- (void)loadGroupItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID callback:(ArrayBlock)callback {
    NSDictionary *params = [self dictionaryWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:nil weekID:nil];
    [self performRequestWithParams:params callback:^(NSString *html, NSError *error) {
        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_GROUP];
        callback(array, error);
    }];
}

- (void)loadWeekItemsWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID callback:(ArrayBlock)callback {
    NSDictionary *params = [self dictionaryWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:nil];
    [self performRequestWithParams:params callback:^(NSString *html, NSError *error) {
        NSArray *array = [FacultyHTMLParser parseWithHTML:html key:KEY_SELECT_WEEK];
        callback(array, error);
    }];
}

- (void)loadScheduleWeekWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID callback:(ArrayBlock)callback {
    NSDictionary *params = [self dictionaryWithFacultyID:facultyID specializationID:specializationID courseID:courseID groupID:groupID weekID:weekID];
    [self performRequestWithParams:params callback:^(NSString *html, NSError *error) {
        NSArray *array = [FacultyHTMLParser scheduleParseWithHTML:html];
        callback(array, error);
    }];
}

- (void)performRequestWithParams:(NSDictionary *)params callback:(DidFinishLoad)callback {
    NSURL *url = [NSURL URLWithString:URL_RASPISANIE];
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:20.0f];
    [theRequest setHTTPMethod:@"POST"];
    
    [theRequest setHTTPBody:[self encodeDictionary:params]];

    [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Connection failed, error: %@", error);
        }
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self storeStateWithParams:params html:html];
        callback(html, error);
    }];
}

- (NSDictionary *)dictionaryWithFacultyID:(NSString *)facultyID specializationID:(NSString *)specializationID courseID:(NSString *)courseID groupID:(NSString *)groupID weekID:(NSString *)weekID {
//    NSMutableDictionary *someDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                     self.viewState, @"__VIEWSTATE",
//                                     self.eventValidation, @"__EVENTVALIDATION",
//                                     nil];
    
    __block NSString *viewState_;
    __block NSString *eventValidation_;
    [[CacheManager sharedInstance] stateWithFacultyID:specializationID ? facultyID : nil
                                     specializationID:courseID ? specializationID : nil
                                             courseID:groupID ? courseID : nil
                                              groupID:weekID ? groupID : nil
                                               weekID:nil
                                             callback:^(NSString *viewState, NSString *eventValidation) {
                                                 viewState_ = viewState;
                                                 eventValidation_ = eventValidation;
                                             }];
    
    NSMutableDictionary *someDict = [NSMutableDictionary dictionary];
    if (viewState_ && eventValidation_) {
        [someDict setObject:viewState_ forKey:@"__VIEWSTATE"];
        [someDict setObject:eventValidation_ forKey:@"__EVENTVALIDATION"];
    }
    
    if (facultyID) {
        [someDict setObject:facultyID forKey:KEY_SELECT_FACULTY];
    }
    if (specializationID) {
        [someDict setObject:specializationID forKey:KEY_SELECT_SPECIALIZATION];
    }
    if (courseID) {
        [someDict setObject:courseID forKey:KEY_SELECT_COURSE];
    }
    if (groupID) {
        [someDict setObject:groupID forKey:KEY_SELECT_GROUP];
    }
    if (weekID) {
        [someDict setObject:weekID forKey:KEY_SELECT_WEEK];
    }
    return someDict;
}

- (NSData *)encodeDictionary:(NSDictionary *)dictionary {
    NSMutableArray *parts = [[NSMutableArray alloc] init];
    for (NSString *key in dictionary) {
        //        NSString *encodedValue = [[dictionary objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                       NULL,
                                                                                                       (CFStringRef)[dictionary objectForKey:key],
                                                                                                       NULL,
                                                                                                       CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                                       kCFStringEncodingUTF8));
        NSString *encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *part = [NSString stringWithFormat: @"%@=%@", encodedKey, encodedValue];
        [parts addObject:part];
    }
    NSString *encodedDictionary = [parts componentsJoinedByString:@"&"];
    return [encodedDictionary dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)storeStateWithParams:(NSDictionary *)params html:(NSString *)html {
    NSString *viewState;
    NSString *eventValidation;
    [FacultyHTMLParser stateParseWithHTML:html viewState:&viewState eventValidation:&eventValidation];
    
    [[CacheManager sharedInstance] storeStateWithFacultyID:params[KEY_SELECT_FACULTY]
                                          specializationID:params[KEY_SELECT_SPECIALIZATION]
                                                  courseID:params[KEY_SELECT_COURSE]
                                                   groupID:params[KEY_SELECT_GROUP]
                                                    weekID:params[KEY_SELECT_WEEK]
                                                 viewState:viewState
                                           eventValidation:eventValidation];
    
    self.viewState = viewState;
    self.eventValidation = eventValidation;
}

@end

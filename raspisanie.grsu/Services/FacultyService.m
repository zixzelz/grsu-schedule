//
//  RaspisanieManager.m
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "FacultyService.h"

#define FACULTY_ENTITY_NAME @"Faculty"

@interface FacultyService ()

@end

@implementation FacultyService

#pragma mark -

- (void)facultyItemsWithCallback:(ArrayBlock)callback {
    [[Backend sharedInstance] loadFacultyItemsWithCallback:^(NSArray *array, NSError *error) {
        [self removeAllFaculty];
        
        NSMutableArray *result = [NSMutableArray array];
        for (ScheduleItem *item in array) {
            FacultyMO *faculty;
            faculty = [NSEntityDescription insertNewObjectForEntityForName:FACULTY_ENTITY_NAME inManagedObjectContext:[[CoreDataConnection sharedInstance] managedObjectContext]];
            faculty.title = item.title;
            faculty.id = item.id;
            
            [result addObject:faculty];
        }
        [[CoreDataConnection sharedInstance] saveContext];
        
        callback(result, error);
    }];
}

- (void)removeAllFaculty {
    CacheManager *cacheManager = [CacheManager sharedInstance];
    NSArray *faculties = [cacheManager sincCacheWithPredicate:nil entity:FACULTY_ENTITY_NAME];
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataConnection sharedInstance] managedObjectContext];
    for (NSManagedObject *managedObject in faculties) {
        [managedObjectContext deleteObject:managedObject];
    }
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

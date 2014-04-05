//
//  BaseServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "BaseServices.h"

@interface BaseServices () <BaseServicesDelegate>

@property (nonatomic, copy) ArrayBlock callback;

@end

@implementation BaseServices

- (void)reloadDataWithItem:(id)item {
    [self removeDataWithItem:item];
    [self loadDataWithItem:item callback:^(NSArray *array, NSError *error) {
        [self.delegate didLoadData:array error:error];
    }];
}

- (void)removeDataWithItem:(id)item {
    NSArray *items = [self fetchDataWithItem:item];
    
    NSManagedObjectContext *managedObjectContext = [[CoreDataConnection sharedInstance] managedObjectContext];
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
    }
}

- (NSArray *)fetchDataWithItem:(id)item {
    CacheManager *cacheManager = [CacheManager sharedInstance];

    NSPredicate *predicate;
    if (item) {
        predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", [self rootFieldName], item];
    }
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSArray *items = [cacheManager sincCacheWithPredicate:predicate entity:[self entityName] sortDescriptors:sortDescriptors];
    
    return items;
}

- (void)loadDataWithItem:(id)item callback:(ArrayBlock)callback {
    // Need override
}

- (NSString *)rootFieldName {
    return @"";
}

- (NSString *)entityName {
    return @"";
}

#pragma mark - Callback

- (void)setResponseCallback:(ArrayBlock)callback {
    self.callback = callback;
    self.delegate = self;
}

#pragma mark - BaseServicesDelegate

- (void)didLoadData:(NSArray *)items error:(NSError *)error {
    if (self.callback) {
        self.callback(items, error);
        self.callback = nil;
    }
}

@end

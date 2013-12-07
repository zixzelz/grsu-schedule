//
//  BaseServices.m
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "BaseServices.h"

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
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)", [self rootFieldName], item];
    NSArray *items = [cacheManager sincCacheWithPredicate:predicate entity:[self entityName] sortDescriptors:sortDescriptors];
    
    return items;
}

- (void)loadDataWithItem:(id)specialization callback:(ArrayBlock)callback {
    
}

- (NSString *)rootFieldName {
    return @"";
}

- (NSString *)entityName {
    return @"";
}

@end

//
//  BaseServices.h
//  raspisanie.grsu
//
//  Created by Ruslan Maslouski on 12/6/13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Backend.h"
#import "CoreDataConnection.h"
#import "CacheManager.h"

@protocol BaseServicesDelegate;


@interface BaseServices : NSObject

@property (nonatomic, weak) id<BaseServicesDelegate> delegate;

- (void)reloadDataWithItem:(id)item;
- (void)removeDataWithItem:(id)item;
- (NSArray *)fetchDataWithItem:(id)item;

@end


@protocol BaseServicesDelegate <NSObject>

- (void)didLoadData:(NSArray *)items error:(NSError *)error;

@end
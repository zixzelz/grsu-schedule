//
//  CoreDataConnection.h
//  OnlinerRSS
//
//  Created by Ruslan Mas on 17.10.12.
//  Copyright (c) 2012 Ruslan Maslouski. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataConnection : NSObject
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataConnection *) sharedInstance;
- (void)saveContext;
@end

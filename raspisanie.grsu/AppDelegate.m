//
//  AppDelegate.m
//  raspisanie.grsu
//
//  Created by Ruslan on 14.03.13.
//  Copyright (c) 2013 RYSoft. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "CoreDataConnection.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    
    UINavigationController *navController = [UINavigationController new];
    [navController pushViewController:self.viewController animated:NO];
    
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[CoreDataConnection sharedInstance] saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[CoreDataConnection sharedInstance] saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[CoreDataConnection sharedInstance] saveContext];
}

@end

//
//  AppDelegate.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/13/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        GMSServices.provideAPIKey("AIzaSyBSF-hRXIjTMwnB0vwWcaDX-aq7WSy2pAc")

        Flurry.setCrashReportingEnabled(true)
        Flurry.startSession("9W5R9JWXFCGXR7XJ5R83")

        GSReachability.sharedInstance.startNotifier()
        cdh.setup()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        self.cdh.saveContext()
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        self.cdh.saveContext()
    }

    // #pragma mark - Core Data Helper

    lazy var cdstore: CoreDataStore = {
        let cdstore = CoreDataStore()
        return cdstore
    }()

    lazy var cdh: CoreDataHelper = {
        let cdh = CoreDataHelper()
        return cdh
    }()

}


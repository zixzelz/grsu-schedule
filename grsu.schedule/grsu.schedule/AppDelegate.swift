//
//  AppDelegate.swift
//  grsu.schedule
//
//  Created by Ruslan Maslouski on 11/13/14.
//  Copyright (c) 2014 Ruslan Maslouski. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        GMSServices.provideAPIKey("AIzaSyBSF-hRXIjTMwnB0vwWcaDX-aq7WSy2pAc")
        setupFlurry()

        GSReachability.sharedInstance.startNotifier()
        cdh.setup()

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64( 3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), { [weak self] _ in
            self?.cleanCachejob()
        })

        return true
    }

    private func setupFlurry() {

        var builder = FlurrySessionBuilder()
//            .withLogLevel(FlurryLogLevelAll)
            .withCrashReporting(false)

        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            builder = builder.withAppVersion(version)
        }
        Flurry.startSession("9W5R9JWXFCGXR7XJ5R83", withSessionBuilder: builder)
    }

    private func cleanCachejob() {
        ScheduleService().cleanCache()
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


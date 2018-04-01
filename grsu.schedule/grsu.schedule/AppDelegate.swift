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
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey("AIzaSyBSF-hRXIjTMwnB0vwWcaDX-aq7WSy2pAc")
        setupFlurry()
        Fabric.with([Crashlytics.self])

        GSReachability.sharedInstance.startNotifier()
//        cdh.setup()

        let delayTime = DispatchTime.now() + Double(Int64( 3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [weak self] in
            self?.cleanCachejob()
        })

        return true
    }

    fileprivate func setupFlurry() {

        var builder = FlurrySessionBuilder()
//            .withLogLevel(FlurryLogLevelAll)
        .withCrashReporting(false)

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            builder = builder?.withAppVersion(version)
        }
        Flurry.startSession("9W5R9JWXFCGXR7XJ5R83", with: builder)
    }

    fileprivate func cleanCachejob() {
        ScheduleService().cleanCache()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataHelper.saveBackgroundContext()
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    // #pragma mark - Core Data Helper

    lazy var cdstore: CoreDataStore = {
        let cdstore = CoreDataStore()
        return cdstore
    }()

//    lazy var cdh: CoreDataHelper = {
//        let cdh = CoreDataHelper()
//        return cdh
//    }()

}


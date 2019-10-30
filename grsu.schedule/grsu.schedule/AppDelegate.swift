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
import Armchair

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        setupLanguage()
        setupArmchair()
        checkLocal()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        GMSServices.provideAPIKey("AIzaSyBSF-hRXIjTMwnB0vwWcaDX-aq7WSy2pAc")
        setupFlurry()
        Fabric.with([Crashlytics.self])

        GSReachability.sharedInstance.startNotifier()

        // workaround to store DB in main queue for first time
        CoreDataHelper.managedObjectContext.saveIfNeeded()

        let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { [weak self] in
            self?.cleanCachejob()
        })

        window?.backgroundColor = UIColor(named: "NavigationBarColor")

        return true
    }

    private func setupFlurry() {

        var builder = FlurrySessionBuilder()
//            .withLogLevel(FlurryLogLevelAll)
        .withCrashReporting(false)

        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            builder = builder?.withAppVersion(version)
        }
        Flurry.startSession("9W5R9JWXFCGXR7XJ5R83", with: builder)
    }

    private func setupArmchair() {
        // Normally, all the setup would be here.
        // But, because we are presenting a few different setups in the example,
        // The config will be in the view controllers
        //     Armchair.appID("408981381") // Pages
        //
        // It is always best to load Armchair as early as possible
        // because it needs to receive application life-cycle notifications
        //
        // NOTE: The appID call always has to go before any other Armchair calls
        appID = "992531651"
        Armchair.appID(appID)
        Armchair.daysUntilPrompt(7)
        Armchair.usesUntilPrompt(10)
//        Armchair.debugEnabled(true)
//        SKStoreReviewController.requestReview()
    }

    fileprivate func cleanCachejob() {
        ScheduleService().cleanCache().start()
    }

    private func setupLanguage() {
        let code = UserDefaults.selectedLanguage
        Bundle.setLanguage(code: code.code)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.previousLanguageCode = Locale.preferredLanguageCode
        CoreDataHelper.saveBackgroundContext()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        UserDefaults.previousLanguageCode = Locale.preferredLanguageCode
    }

    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        checkLocal()
    }

    func checkLocal() {
        if UserDefaults.previousLanguageCode != Locale.preferredLanguageCode {
            UserDefaults.previousLanguageCode = Locale.preferredLanguageCode
//            cleanCacheExpiredFlags() // todo
        }
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


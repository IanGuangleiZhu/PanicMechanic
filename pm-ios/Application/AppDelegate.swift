//
//  AppDelegate.swift
//  pm-ios
//
//  Created by Synbrix Software on 8/14/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyBeaver
import FirebaseDynamicLinks
import Purchases

let log = SwiftyBeaver.self

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // MARK: - Lifecycle
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window)
        
        // Enable keyboard manager
        IQKeyboardManager.shared.enable = true
        
        // Initialize RevenueCat
        #if DEBUG
        Purchases.debugLogsEnabled = true
        #endif
        Purchases.configure(withAPIKey: "saDrjBWuPSmUsXQjSndRKrIhoFusgEGJ")
        
        initializeTheme()
        initializeLogger()
        
        appCoordinator?.start()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: "")
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        // Clicking dynamic link without app being installed, following through with install, and then starting app will trigger this.
        log.info("Receiving url through custom scheme!", context: url.absoluteString)
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleDynamicLink(dynamicLink: dynamicLink)
            return true
        } else {
            // Maybe handle incoming url from other source (Facebook, Google sign-in etc.)
            log.info("Link coming from separate source.")
            return false
        }
    }
        
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if let incomingURL = userActivity.webpageURL {
            log.info("Receiving universal link:", context: incomingURL)
            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { dynamicLink, error in
                if let error = error {
                    log.error("Error handling dynamic link:", context: error)
                    return
                }
                if let dynamicLink = dynamicLink {
                    self.handleDynamicLink(dynamicLink: dynamicLink)
                }
            }
            return linkHandled
        }
        return false
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        log.warning("Application will resign active.")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        log.warning("Application will enter background.")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        log.warning("Application will enter foreground.")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        log.warning("Application did become active.")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        log.warning("Application will terminate.")
    }
    
}

// MARK: - Private Helpers
extension AppDelegate {
    
    private func initializeTheme() {
        UINavigationBar.appearance().tintColor = Colors.panicRed // Bar button text Color
        // Title font and color
        if let font = UIFont(name: "SFCompactRounded-Bold", size: 20.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : Colors.panicRed]
        } else {
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : Colors.panicRed]
        }
        
        // Tab Bar
        UITabBar.appearance().tintColor = Colors.panicRed
        
        // Segmented Controls
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.panicRed], for: .normal)
    }
    
    private func initializeLogger() {
        // add log destinations. at least one is needed!
        let console = ConsoleDestination()  // log to Xcode Console
        
        console.minLevel = .info
        // use custom format and set console output to short time, log level & message
        console.format = "[$DHH:mm:ss.SSS$d] $C$L$c $N.$F:$l ($T) - $M $X"
        
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        
    }
    
    private func handleDynamicLink(dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url else {
            log.warning("No URL was received, skipping dynamic link.")
            return
        }
        log.info("Dynamic link URL received:", context: url)
        let deepLink = DeepLink(dynamicLink: dynamicLink)
        self.appCoordinator?.start(deepLink: deepLink)
    }
    
}

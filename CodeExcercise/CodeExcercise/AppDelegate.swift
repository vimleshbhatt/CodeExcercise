//
//  AppDelegate.swift
//  CodeExcercise
//
//  Created by fgb on 2/11/18.
//  Copyright © 2018 vimlesh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Create a window and the initial view controller to show in the window.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Create a navigationController with our homeViewController and make the navigationController as the rootViewController of the window.
        let homeViewController = HomeViewController() as UIViewController
        homeViewController.view.backgroundColor = .white
        
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.navigationBar.isTranslucent = false
        
        window!.rootViewController = homeViewController
        self.window?.rootViewController = navigationController
        
        // Make the controller visible on the window.
        window!.makeKeyAndVisible()
        
        // Testing a new push 8
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}


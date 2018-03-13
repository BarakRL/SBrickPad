//
//  AppDelegate.swift
//  SBrick-Controller
//
//  Created by Barak Harel on 4/24/17.
//  Copyright © 2017 Barak Harel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
                
        UIButton.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UIBarButtonItem.appearance().setTitleTextAttributes([.font: UIFont.gillSansLight(size: 18)], for: .normal)
        
        UINavigationBar.appearance().titleTextAttributes = [.font: UIFont.gillSans(size: 18), .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.005186316557, green: 0.5101435184, blue: 0.6784499288, alpha: 1)
        UINavigationBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        UIView.appearance().tintColor = #colorLiteral(red: 0.005186316557, green: 0.5101435184, blue: 0.6784499288, alpha: 1)
        
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


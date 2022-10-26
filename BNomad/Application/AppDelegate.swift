//
//  AppDelegate.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/13.
//

import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var endTime: Date? = Date()
    static var restartTime: Date? = Date()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        AppDelegate.restartTime = Date()
        if let date = UserDefaults.standard.value(forKey: "endTime") as? Date {
            AppDelegate.endTime = date
        }
        if let count = UserDefaults.standard.value(forKey: "savedTime") as? Int {
            MapViewController.count = count
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        UserDefaults.standard.set(Date(), forKey: "endTime")
        UserDefaults.standard.set(MapViewController.count, forKey: "savedTime")
    }
    



}


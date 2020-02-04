//
//  AppDelegate.swift
//  MyDiet
//
//  Created by Артем Чиглинцев on 11/12/2019.
//  Copyright © 2019 Артем Чиглинцев. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let firstLaunchKey = "FirstLaunchKey"
        
        if UserDefaults.standard.bool(forKey: firstLaunchKey) {

        }else {
            UserDefaults.standard.setValue(true, forKey: firstLaunchKey)
            TodayScreenDataManager.instance.createAppDays()
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
        CoreDataManager.instance.saveContext(forEntity: nil)
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


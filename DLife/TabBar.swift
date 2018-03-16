//
//  TabBar.swift
//  DLife
//
//  Created by 康晉嘉 on 2018/2/26.
//  Copyright © 2018年 康晉嘉. All rights reserved.
//

import UIKit

class TabBar: UITabBar {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let tabBarController = self.window?.rootViewController as! UITabBarController
        tabBarController.tabBar.tintColor = UIColor.yellow
        tabBarController.tabBar.barTintColor = UIColor.blue
        tabBarController.tabBar.unselectedItemTintColor = UIColor.green
        return true
    }
}

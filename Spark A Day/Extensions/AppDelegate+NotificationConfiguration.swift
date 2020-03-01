//
//  AppDelegate+NotificationConfiguration.swift
//  Spark A Day
//
//  Created by Malcom Jones on 2/13/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import os.log

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    
    //MARK: - Notification COnfiguration
    func registerPushNotifications() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: { [weak self] granted, error in
            
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        })
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
//            print("\(self.className): Notifications settings: \(settings)")
        })
    }
    
    func defineNotifications() {
        //TODO: - Build notifications based on spreadsheet of Sparks
        //Actions
        
        
        //Categories
        let categorySpark = UNNotificationCategory(identifier: "SPARK",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
        //Register Categories
        UNUserNotificationCenter.current().setNotificationCategories([categorySpark])
        
    }
    
    //MARK: - Notification Delegate Functions
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let categoryID = response.notification.request.content.categoryIdentifier
        let actionID = response.actionIdentifier
        
        if actionID == UNNotificationDismissActionIdentifier {
            os_log("User dismissed notification", log: OSLog.notificationConfig, type: .info)
        }
            
        else if actionID == UNNotificationDefaultActionIdentifier {
            if categoryID == "SPARK" {
                os_log("User selected notification", log: OSLog.notificationConfig, type: .info)
                let title = response.notification.request.content.userInfo["title"] as! String
                let body = response.notification.request.content.userInfo["body"] as! String
                let longBody = response.notification.request.content.userInfo["longBody"] as! String

                let sparkDictionary: [String: String] = ["title": title, "body": body, "longBody": longBody]

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationSelected"), object: nil, userInfo: sparkDictionary)
            }
        }
        
        completionHandler()
    }

}

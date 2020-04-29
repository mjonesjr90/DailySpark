//
//  ViewController.swift
//  Spark A Day
//
//  Created by Malcom Jones on 2/13/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import SwiftUI
import os.log

class ViewController: UIViewController {
    
    //User Defaults
    let defaults = UserDefaults.standard
    
    var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"
    
    var beginDate: Date?
    var beginDateKey = "BeginDateKey"
    
    var configured: Bool = false
    var configuredKey = "ConfiguredKey"
    
    var notificationHour: Int?
    var notificationHourKey = "notificationHourKey"
    
    var notificationMin: Int?
    var notificationMinKey = "notificationMinKey"
    
    //UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var titleLabelHolder: String = ""
    var bodyLabelHolder: String = ""
    
    //Formatting
    var dfs = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("viewDidLoad", log: OSLog.viewController, type: .info)
//        addNotificationObservers()
        
        dfs.dateStyle = .short
        dfs.timeStyle = .short
        dfs.locale = .current

        
        //For testing, reset everytime
//        reset()
        
        //Check what is saved in User Defaults
        checkUserDefaults()
        
        //Initial scheduling should only occur if this is the first time the app
        //is opened or if the user decides to reset the notifications
        if(!configured) {
            //Set begin date
            beginDate = Date()
            defaults.set(beginDate, forKey: beginDateKey)
            
            //Build array from file
            let sab = SparkArrayBuilder(file: "sparks")
            
            //Use array to schedule notifications
            os_log("Spark List Count: %d", log: OSLog.viewController, type: .info, sab.sparkArray.count)
            var sb = SparkBuilder(array: sab.sparkArray)
            sb.scheduleNotifications()
        }
        
        //Resechedule notifications that haven't been sent yet, up to 64 max if applicable
//        if(configured) {
//            //Build array from file
//            let sab = SparkArrayBuilder(file: "sparks")
//
//            //Use array to schedule notifications
//            os_log("Spark List Count: %d", log: OSLog.viewController, type: .info, sab.sparkArray.count)
//            var sb = SparkBuilder(array: sab.sparkArray)
//            sb.cleanSparkTracker()
//
//            //Resechedule
//            sb.scheduleNotifications()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        os_log("viewWillAppear", log: OSLog.viewController, type: .info)
        update()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        os_log("viewWillDisappear", log: OSLog.viewController, type: .info)
        update()
    }
    
    // selector that was defined above
    @objc func willEnterForeground() {
        update()
    }
    
    func update() {
        titleLabel.text = "DailySpark"
        bodyLabel.text = ""
        
        if(configured) {
            //Build array from file
            let sab = SparkArrayBuilder(file: "sparks")
            
            //Use array to schedule notifications
            os_log("Spark List Count: %d", log: OSLog.viewController, type: .info, sab.sparkArray.count)
            var sb = SparkBuilder(array: sab.sparkArray)
            sb.cleanSparkTracker()
            
            //Resechedule
            sb.scheduleNotifications()
        }
//        os_log("updateUI", log: OSLog.viewController, type: .info)
//        os_log("titleLabelHolder: %s", log: OSLog.viewController, type: .info, titleLabelHolder)
//        os_log("bodyLabelHolder: %s", log: OSLog.viewController, type: .info, bodyLabelHolder)
//        if(titleLabelHolder == "" || bodyLabelHolder == "") {
//            titleLabel.text = "Daily Spark"
//            bodyLabel.text = ""
//        }
//        else {
//            titleLabel.text = titleLabelHolder
//            bodyLabel.text = bodyLabelHolder
//        }
    }
    
    func deriveSparks(array: [[String]]) -> [[String]] {
        //Read in full spark array list
        //Pull out Spark IDs from spark tracker that have passed using current date vs begin date into array
        //Use this new array to determine which sparks from the full array to return
        
        os_log("Deriving sparks ...", log: OSLog.sparkTableView, type: .info)
        var loggedSparks: [[String]] = []
        let keyHolder = sparkTracker.keys
        print(keyHolder)
        
        for key in keyHolder {
            let date = dfs.date(from: key)
            //If date is in the past, add the corresponding spark to log
            if(Date() >= date!) {
                //Iterate through the master array and add the spark to log once found
                for a in array {
                    if(a.contains(sparkTracker[key]!)) {
                        loggedSparks.append(a)
                    }
                }
            }
        }
        
        print(loggedSparks)
        return loggedSparks
    }
    
    @IBAction func sparkLogButtonPress(_ sender: Any) {
        //Build array from file
        let sab = SparkArrayBuilder(file: "sparks")
        let sparkArray = deriveSparks(array: sab.sparkArray)
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let sparkListController = SparkLogList(
            sparkArray: sparkArray,
            dismissAction: {
                self.dismiss( animated: true, completion: nil )
        })
        let hostController = UIHostingController(rootView: sparkListController)
//        let hostController = UIHostingController(rootView: SparkLogList(sparkArray: sparkArray))
        hostController.modalPresentationStyle = .fullScreen
        present(hostController, animated: true)
    }
    
    func checkUserDefaults(){
        os_log("Checking user defaults ...", log: OSLog.viewController, type: .info)
       
        os_log("Checking if Configured", log: OSLog.viewController, type: .info)
        if let isConfigured = defaults.object(forKey: configuredKey) as? Bool {
            configured = isConfigured
            print("Configured: ", configured)
        }
        
        os_log("Checking Begin Date", log: OSLog.viewController, type: .info)
        if let dateBegan = defaults.object(forKey: beginDateKey) as? Date {
            beginDate = dateBegan
            print("Begin Date: ", dfs.string(from: beginDate!))
        }
        
        os_log("Checking Spark Tracker", log: OSLog.viewController, type: .info)
        if let sparksTracked = defaults.object(forKey: sparkTrackerKey) as? [String: String] {
            sparkTracker = sparksTracked
            print("Spark Tracker: ", sparkTracker)
        }
        
        os_log("Checking Notification Hour", log: OSLog.viewController, type: .info)
        if let notHour = defaults.object(forKey: notificationHourKey) as? Int {
            notificationHour = notHour
        } else {
            notificationHour = 8
        }
        print("Notification Hour: ", notificationHour!)
        
        os_log("Checking Notification Minute", log: OSLog.viewController, type: .info)
        if let notMin = defaults.object(forKey: notificationMinKey) as? Int {
            notificationMin = notMin
        } else {
            notificationMin = 00
        }
        print("Notification Min: ", notificationMin!)
    }
    
    func reset() {
        sparkTracker = [:]
        defaults.set(sparkTracker, forKey: sparkTrackerKey)
        
        beginDate = Date()
        defaults.set(beginDate, forKey: beginDateKey)
        
        configured = false
        defaults.set(configured, forKey: configuredKey)
    }
  
//    func addNotificationObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(notificationSelected(notification:)), name: NSNotification.Name(rawValue: "notificationSelected"), object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
//    }
    
    /**
     This function runs when a user selects the notifiction. When the notification
     is pressed, the app opens and this method modifies the UI with the info from the notification..
     
     - Parameters:
        - notification: the current notification that was selected
     */
//    @objc func notificationSelected(notification: NSNotification) {
//        os_log("Pulling data from notification ...", log: OSLog.viewController, type: .info)
//        if let title = notification.userInfo?["title"] as? String {
//            os_log("title: %s", log: OSLog.viewController, type: .info, title)
//            self.titleLabelHolder = title
//        }
//
//        if let body = notification.userInfo?["longBody"] as? String {
//            os_log("body: %s", log: OSLog.viewController, type: .info, body)
//            self.bodyLabelHolder = body
//        }
//        updateUI()
//    }
}


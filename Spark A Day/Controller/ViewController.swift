//
//  ViewController.swift
//  Spark A Day
//
//  Created by Malcom Jones on 2/13/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    //User Defaults
    let defaults = UserDefaults.standard

    var sparkLogArray: [Int] = []
    var sparkLogKey = "SparkLogKey"
    
    var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"
    
    var beginDate: Date?
    var beginDateKey = "BeginDateKey"
    
    var configured: Bool = false
    var configuredKey = "ConfiguredKey"
    
    //UI
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    //Formatting
    var df = DateFormatter()
    var dfs = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addNotificationObservers() 
        
        df.dateStyle = .full
        dfs.dateStyle = .short
        
        //For testing, reset everytime
        reset()
        
        //Check what is saved in User Defaults
        checkUserDefaults()
        
        //Scheduling should only occur if this is the first time the app
        //is opened or if the user decides to reset the notifications
        if(!configured) {
            //Set begin date
            beginDate = Date()
            defaults.set(beginDate, forKey: beginDateKey)
            
            //Build array from file
            let sab = SparkArrayBuilder(file: "sparks")
            
            //Use array to schedule notifications
            var sb = SparkBuilder(array: sab.sparkArray)
            sb.scheduleNotifications()
        }
        
        //Resechedule notifications that haven't been sent yet, up to 64 max if applicable
        if(configured) {
            //Build array from file
            let sab = SparkArrayBuilder(file: "sparks")
            
            //Use array to schedule notifications
            var sb = SparkBuilder(array: sab.sparkArray)
            sb.cleanSparkTracker()
            
            //Resechedule
            sb.scheduleNotifications()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        updateUI()
    }
    
    // selector that was defined above
    @objc func willEnterForeground() {
        updateUI()
    }
    
    func updateUI() {
        titleLabel.text = "Daily Spark"
        bodyLabel.text = ""
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
    }
    
    func reset() {
        sparkTracker = [:]
        defaults.set(sparkTracker, forKey: sparkTrackerKey)
        
        beginDate = Date()
        defaults.set(dfs.string(from: beginDate!), forKey: beginDateKey)
        
        configured = false
        defaults.set(configured, forKey: configuredKey)
    }
  
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(notificationSelected(notification:)), name: NSNotification.Name(rawValue: "notificationSelected"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    /**
     This function runs when a user selects the notifiction. When the notification
     is pressed, the app opens and this method modifies the UI with the info from the notification..
     
     - Parameters:
        - notification: the current notification that was selected
     */
    @objc func notificationSelected(notification: NSNotification) {
        os_log("Pulling data from notification ...", log: OSLog.viewController, type: .info)
        if let title = notification.userInfo?["title"] as? String {
            self.titleLabel.text = title
        }
        
        if let body = notification.userInfo?["longBody"] as? String {
            self.bodyLabel.text = body
        }
    }
}


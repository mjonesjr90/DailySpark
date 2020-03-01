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
    
    var df = DateFormatter()
    var dfs = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        df.dateStyle = .full
        dfs.dateStyle = .short
        
        //For testing, reset everytime
//        reset()
        
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
    
//    func old() {
//        //Check if app has been opened before and if a begin/end date has been set
//        //If app has already been opened, a date will have been set
//        print("Checking for begin date")
//        if let begin = defaults.object(forKey: beginDateKey) as? Date {
//            beginDate = begin
//            print("Begin: ", df.string(from: beginDate!))
//
//            scheduleNotifications(date: today)
//
//            //Check for end date
//            print("Checking for end date")
//            if let end = defaults.object(forKey: endDateKey) as? Date {
//                endDate = end
//                print("End: ", df.string(from: endDate!))
//            }
//        }
//        //If begin is not found, set the date to today, add it to defaults and then derive end date and set default
//        else {
//            print("Begin date not found - creating begin date ...")
//            beginDate = Date()
//            defaults.set(beginDate, forKey: beginDateKey)
//            print("Begin: ", df.string(from: beginDate!))
//
//            endDate = Calendar.current.date(byAdding: .second, value: 10, to: beginDate!)
//            defaults.set(endDate, forKey: endDateKey)
//            print("End: ", df.string(from: endDate!))
//        }
//        
//        //Check if the current date is after the end date
//        //If it is, recalculate begin and end dates and reschedule notifications
//        //Reset schedule for reminder notification
//        if(today > endDate!) {
//            beginDate = Date()
//            defaults.set(beginDate, forKey: beginDateKey)
//            print("Begin: ", df.string(from: beginDate!))
//
//            endDate = Calendar.current.date(byAdding: .second, value: 60, to: beginDate!)
//            defaults.set(endDate, forKey: endDateKey)
//            print("End: ", df.string(from: endDate!))
//
//            scheduleNotifications(date: today)
//        }
//    }
}


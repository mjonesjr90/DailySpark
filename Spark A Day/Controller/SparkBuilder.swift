//
//  SparkBuilder.swift
//  Spark A Day
//
//  Created by Malcom Jones on 2/25/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

struct SparkBuilder {
    
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
    
    var sparkList: [[String]] = []
    
    var maxNotifications: Int?
    
    init(array: [[String]]) {
        checkUserDefaults()
        sparkList = array
        maxNotifications = countMax()
    }
    
    mutating func scheduleNotifications() {
        let date = Date()
        print("SCHEDULING NOTIFICATIONS")
        
        df.dateStyle = .full
        dfs.dateStyle = .short
        dfs.timeStyle = .short
        dfs.locale = .current
        
        var counter = 1
        let content = UNMutableNotificationContent()
        
        while (counter <= maxNotifications!) {
            
            //Get next spark to be used
            let random = getRandomSpark(numberOfSparks: sparkList.count)
            
            //Build notification content
            content.title = sparkList[random][1]
            content.body = sparkList[random][2]
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "categorySpark"
            
            let val = counter * 1
            let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Calendar.current.date(byAdding: .day, value: val, to: date)!)
            
            counter+=1
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
            
            let datestring = dfs.string(from: trigger.nextTriggerDate()!)
            os_log("(%d) Spark %s Added for %s", log: OSLog.sparkBuilder, type: .info, counter-1, sparkList[random][4], datestring)
            
            let request = UNNotificationRequest(identifier: sparkList[random][4], content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            })
            
            //Add spark to spark tracker
            sparkTracker[datestring] = sparkList[random][4]
            defaults.set(sparkTracker, forKey: sparkTrackerKey)
        }
        
        configured = true
        defaults.set(configured, forKey: configuredKey)
    }
    
    mutating func rescheduleNotifications() {
        
    }
     
    /**
     Count the amount of days that have passed and subtract that from total number of sparks.
     This is compared to 64 (the max amount of notifications) and is used as the maximum number
     of random numbers/schedules available.
     */
    
    func countMax() -> Int {
        let daysPassed = Calendar.current.dateComponents([.day], from: beginDate!, to: Date()).day!
        let remainingDays = sparkList.count - daysPassed
        
        //If remaining days is less than 64, use that - otherwise use 64 as the max
        return (remainingDays < 64) ? remainingDays : 64
    }
    
    /**
     A random spark is chosen to be added to the queue for notifications. If it's already been schedule, it will be skipped. The number
     of times this function is called should be bound by the max number of notifications remaining
     */

    private mutating func getRandomSpark(numberOfSparks: Int) -> Int {
        //Get a random number from 0 to the amount of SPARKS
        var n = Int.random(in: 0 ..< numberOfSparks)
        
        //Use that random number to get a random ID from spark array to see if it's already been scheduled
        //It's the 5th element in a spark array
        //If it has been tracked, the while loop will continue until a untracked spark is found
        var randomSparkID = sparkList[n][4]
        while (sparkTracker.values.contains(randomSparkID)) {
            n = Int.random(in: 0 ..< numberOfSparks)
            randomSparkID = sparkList[n][4]
        }
        return n
    }
    
    mutating func cleanSparkTracker() {
        os_log("Cleaning Spark Tracker ...", log: OSLog.sparkBuilder, type: .info)
        var dayCounter = 1
        var day = Calendar.current.date(byAdding: .day, value: dayCounter, to: Date())!
        var dayString = dfs.string(from: day)
        
        while(sparkTracker.keys.contains(dayString)) {
            os_log("Removing: [%s:%s]", log: OSLog.sparkBuilder, type: .info, dayString, sparkTracker[dayString]!)
            sparkTracker.removeValue(forKey: dayString)

            dayCounter += 1
            day = Calendar.current.date(byAdding: .second, value: dayCounter, to: Date())!
            dayString = dfs.string(from: day)
        }
        defaults.set(sparkTracker, forKey: sparkTrackerKey)
    }
    
    mutating func checkUserDefaults(){
        os_log("Checking user defaults ...", log: OSLog.sparkBuilder, type: .info)
       
        os_log("Checking if Configured", log: OSLog.sparkBuilder, type: .info)
        if let isConfigured = defaults.object(forKey: configuredKey) as? Bool {
            configured = isConfigured
            print("Configured: ", configured)
        }
        
        os_log("Checking Begin Date", log: OSLog.sparkBuilder, type: .info)
        if let dateBegan = defaults.object(forKey: beginDateKey) as? Date {
            beginDate = dateBegan
            print("Begin Date: ", dfs.string(from: beginDate!))
        }
        
        os_log("Checking Spark Tracker", log: OSLog.sparkBuilder, type: .info)
        if let sparksTracked = defaults.object(forKey: sparkTrackerKey) as? [String: String] {
            sparkTracker = sparksTracked
            print("Spark Tracker: ", sparkTracker)
        }
    }
    
}

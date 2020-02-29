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
    
    var df = DateFormatter()
    
    var sparkList: [[String]] = []
//    var numberOfSparks = 10
    var chosenSpark: Int?
    
//    init(date: Date) {
//        scheduleNotifications(date: date)
//    }
    
    init(array: [[String]]) {
        sparkList = array
    }
    
    mutating func scheduleNotifications() {
        let date = Date()
        print("SCHEDULING NOTIFICATIONS")
        
        df.dateStyle = .full
        
        var counter = 1
        var sparkIdHolder = [Int]()
        let content = UNMutableNotificationContent()
        
        while (counter <= sparkList.count) {
            let random = getRandomSpark(numberOfSparks: sparkList.count)
            sparkIdHolder.append(random)
            os_log("Count: %d", log: OSLog.sparkBuilder, type: .info, counter)
            os_log("Appending %d to SparkHolder", log: OSLog.sparkBuilder, type: .info, random)
            
            content.title = sparkList[random][1]
            content.body = sparkList[random][2]
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "categorySpark"
            
            let val = counter * 10
            let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Calendar.current.date(byAdding: .second, value: val, to: date)!)
            
            counter+=1
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
            
            let datestring = df.string(from: trigger.nextTriggerDate()!)
            os_log("Notification %d Added for %{time_t}d", log: OSLog.sparkBuilder, type: .info, counter-1, datestring)
            
            let request = UNNotificationRequest(identifier: sparkList[random][4], content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            })
        }
    }
        
    mutating func getRandomSpark(numberOfSparks: Int) -> Int {
            //Get a random number from 0 to the amount of SPARKS
        var n = Int.random(in: 0 ..< numberOfSparks)
            
            if (sparkLogArray.count == numberOfSparks) {
                //All of the sparks have been used - time to reset
                print("All of the SPARKS have been used - time to reset")
                sparkLogArray = []
                defaults.set(sparkLogArray, forKey: sparkLogKey)
            }
            else {
                //While the log array has that random number, attempt to find another that has not already been used
                while (sparkLogArray.contains(n)) {
                    n = Int.random(in: 0 ..< numberOfSparks)
                }
                
                //Once a unique random number has been found, add it to the user defaults array and return it
                sparkLogArray.append(n)
                defaults.set(sparkLogArray, forKey: sparkLogKey)
            }
        
            os_log("Array: %@", log: OSLog.sparkBuilder, type: .info, sparkLogArray)
            return n
        }
        
        mutating func checkForLoggedSparks(){
            os_log("Checking for logged Sparks", log: OSLog.sparkBuilder, type: .info)
            if let sparksLogged = defaults.object(forKey: sparkLogKey) as? [Int] {
                sparkLogArray = sparksLogged
                os_log("Array: %@", log: OSLog.sparkBuilder, type: .info, sparkLogArray)
            }
        }
    
}

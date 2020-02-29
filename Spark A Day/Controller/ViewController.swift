//
//  ViewController.swift
//  Spark A Day
//
//  Created by Malcom Jones on 2/13/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //User Defaults
    let defaults = UserDefaults.standard

    var sparkLogArray: [Int] = []
    var sparkLogKey = "SparkLogKey"
    
    var beginDate: Date?
    var beginDateKey = "BeginDateKey"
    
    var endDate: Date?
    var endDateKey = "EndDateKey"
    
    var df = DateFormatter()
    
    var sparkList = [
        "SPARK 1",
        "SPARK 2",
        "SPARK 3",
        "SPARK 4",
        "SPARK 5",
        "SPARK 6",
        "SPARK 7",
        "SPARK 8",
        "SPARK 9",
        "SPARK 10",
    ]
    var numberOfSparks = 10
    var chosenSpark: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let today = Date()
        
        df.dateStyle = .full
        
        sparkLogArray = []
        defaults.set(sparkLogArray, forKey: sparkLogKey)
        
        //Check what is saved in User Defaults
        checkForLoggedSparks()
        
//        var sb = SparkBuilder()
//        sb.scheduleNotifications()

        let sab = SparkArrayBuilder(file: "sparks")
    }
    
    /**
     In order to get dynamic content into notifications, the use of Push Notifications is required. To avoid this,
     we can pre-cache 5 notifications (a weeks worth) and schedule them. These 5 notifications are refreshed
     whenever the app is loaded.
     
     If the app is not opened within those 5 days, a reminder notification is sent to notify the user. If the user still
     does not respond to the app, th notifications will stop until the user opens it.
     
     
     */
    @IBAction func testButtonPress(_ sender: UIButton) {

        let content1 = UNMutableNotificationContent()
        content1.title = "Spark A Day"
        content1.body = sparkList[getRandomSpark()]
        content1.sound = UNNotificationSound.default
        content1.categoryIdentifier = "categorySpark"
        
        let content2 = UNMutableNotificationContent()
        content2.title = "Spark A Day"
        content2.body = sparkList[getRandomSpark()]
        content2.sound = UNNotificationSound.default
        content2.categoryIdentifier = "categorySpark"
        
        let content3 = UNMutableNotificationContent()
        content3.title = "Spark A Day"
        content3.body = sparkList[getRandomSpark()]
        content3.sound = UNNotificationSound.default
        content3.categoryIdentifier = "categorySpark"
        
        let content4 = UNMutableNotificationContent()
        content4.title = "Spark A Day"
        content4.body = sparkList[getRandomSpark()]
        content4.sound = UNNotificationSound.default
        content4.categoryIdentifier = "categorySpark"
        
        let content5 = UNMutableNotificationContent()
        content5.title = "Spark A Day"
        content5.body = sparkList[getRandomSpark()]
        content5.sound = UNNotificationSound.default
        content5.categoryIdentifier = "categorySpark"
        
        let trigger1 = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let trigger2 = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let trigger3 = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        let trigger4 = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
        let trigger5 = UNTimeIntervalNotificationTrigger(timeInterval: 25, repeats: false)

        let request1 = UNNotificationRequest(identifier: "SPARK1", content: content1, trigger: trigger1)
        let request2 = UNNotificationRequest(identifier: "SPARK2", content: content2, trigger: trigger2)
        let request3 = UNNotificationRequest(identifier: "SPARK3", content: content3, trigger: trigger3)
        let request4 = UNNotificationRequest(identifier: "SPARK4", content: content4, trigger: trigger4)
        let request5 = UNNotificationRequest(identifier: "SPARK5", content: content5, trigger: trigger5)

        UNUserNotificationCenter.current().add(request1, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(request2, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(request3, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(request4, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(request5, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })

    }
    
    func scheduleNotifications(date: Date) {
        print("SCHEDULING NOTIFICATIONS")
        
        let content1 = UNMutableNotificationContent()
        content1.title = "Spark A Day"
        content1.body = sparkList[getRandomSpark()]
        content1.sound = UNNotificationSound.default
        content1.categoryIdentifier = "categorySpark"
        
        let content2 = UNMutableNotificationContent()
        content2.title = "Spark A Day"
        content2.body = sparkList[getRandomSpark()]
        content2.sound = UNNotificationSound.default
        content2.categoryIdentifier = "categorySpark"
        
        let content3 = UNMutableNotificationContent()
        content3.title = "Spark A Day"
        content3.body = sparkList[getRandomSpark()]
        content3.sound = UNNotificationSound.default
        content3.categoryIdentifier = "categorySpark"
        
        let content4 = UNMutableNotificationContent()
        content4.title = "Spark A Day"
        content4.body = sparkList[getRandomSpark()]
        content4.sound = UNNotificationSound.default
        content4.categoryIdentifier = "categorySpark"
        
        let content5 = UNMutableNotificationContent()
        content5.title = "Spark A Day"
        content5.body = sparkList[getRandomSpark()]
        content5.sound = UNNotificationSound.default
        content5.categoryIdentifier = "categorySpark"
        
        let contentReminder = UNMutableNotificationContent()
        contentReminder.title = "Spark A Day"
        contentReminder.body = "Open up your app to check out more SPARKS!"
        contentReminder.sound = UNNotificationSound.default
        contentReminder.categoryIdentifier = "categorySpark"
        
        let t1Components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let t2Components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Calendar.current.date(byAdding: .second, value: 10, to: date)!)
        let t3Components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Calendar.current.date(byAdding: .second, value: 20, to: date)!)
        let t4Components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Calendar.current.date(byAdding: .second, value: 30, to: date)!)
        let t5Components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Calendar.current.date(byAdding: .second, value: 40, to: date)!)
//        let tReminderComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Calendar.current.date(byAdding: .second, value: 60, to: date)!)
        
        
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: t1Components, repeats: false)
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: t2Components, repeats: false)
        let trigger3 = UNCalendarNotificationTrigger(dateMatching: t3Components, repeats: false)
        let trigger4 = UNCalendarNotificationTrigger(dateMatching: t4Components, repeats: false)
        let trigger5 = UNCalendarNotificationTrigger(dateMatching: t5Components, repeats: false)
        let triggerReminder = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        let request1 = UNNotificationRequest(identifier: "SPARK1", content: content1, trigger: trigger1)
        let request2 = UNNotificationRequest(identifier: "SPARK2", content: content2, trigger: trigger2)
        let request3 = UNNotificationRequest(identifier: "SPARK3", content: content3, trigger: trigger3)
        let request4 = UNNotificationRequest(identifier: "SPARK4", content: content4, trigger: trigger4)
        let request5 = UNNotificationRequest(identifier: "SPARK5", content: content5, trigger: trigger5)
        let requestReminder = UNNotificationRequest(identifier: "SPARKREMINDER", content: contentReminder, trigger: triggerReminder)

        UNUserNotificationCenter.current().add(request1, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(request2, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(request3, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(request4, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(request5, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
        UNUserNotificationCenter.current().add(requestReminder, withCompletionHandler: {(error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        })
    }
    
    func getRandomSpark() -> Int {
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
        
        print("Array: %@", sparkLogArray)
        return n
    }
    
    func checkForLoggedSparks(){
        print("Checking for logged Sparks")
        if let sparksLogged = defaults.object(forKey: sparkLogKey) as? [Int] {
            sparkLogArray = sparksLogged
            print("Array: ", sparkLogArray)
        }
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


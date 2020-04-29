//
//  SparkLogView.swift
//  Spark A Day
//
//  Created by Malcom Jones on 3/1/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import SwiftUI
import UserNotifications
import os.log

struct SparkLogList: View {
    
    //User Defaults
    let defaults = UserDefaults.standard
    
    var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"
    
    var beginDate: Date?
    var beginDateKey = "BeginDateKey"
    
    var sparkArray: [[String]] = []
    
    var dfs = DateFormatter()
    
    var sparkHeader: String = ""
    var sparkCategory: String = ""
    
    init() {
        dfs.dateStyle = .short
        dfs.timeStyle = .short
        dfs.locale = .current

        checkUserDefaults()
        
        //Build array from file
        let sab = SparkArrayBuilder(file: "sparks")
        sparkArray = deriveSparks(array: sab.sparkArray)
    }
    
    var body: some View {
        List {
            HStack {
                Text("Spark1")
            }
        }
    }
    
    mutating func checkUserDefaults(){
        os_log("Checking user defaults ...", log: OSLog.sparkTableView, type: .info)
       
        os_log("Checking Spark Tracker", log: OSLog.sparkTableView, type: .info)
        if let sparksTracked = defaults.object(forKey: sparkTrackerKey) as? [String: String] {
            sparkTracker = sparksTracked
            print("Spark Tracker: ", sparkTracker)
        }
        
        os_log("Checking Begin Date", log: OSLog.sparkTableView, type: .info)
        if let dateBegan = defaults.object(forKey: beginDateKey) as? Date {
            beginDate = dateBegan
            print("Begin Date: ", dfs.string(from: beginDate!))
        }
    }
    
    mutating func deriveSparks(array: [[String]]) -> [[String]] {
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
}

struct SparkLogView_Previews: PreviewProvider {
    static var previews: some View {
        SparkLogList()
    }
}

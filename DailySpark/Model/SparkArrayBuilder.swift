//
//  SparkArrayBuilder.swift
//  Spark A Day
//
//  Created by Malcom Jones on 2/29/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

class SparkArrayBuilder: ObservableObject {
    
    //User Defaults
    let defaults = UserDefaults.standard

    var filePath: String?
    @Published var sparkArray = [[String]]()
    @Published var derivedSparkArray = [[String]]()
    var dfs = DateFormatter()
    
    var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"
    
    init(file: String) {
        dfs.dateStyle = .short
        dfs.timeStyle = .short
        dfs.locale = .current
        
        if let sparksTracked = defaults.object(forKey: sparkTrackerKey) as? [String: String] {
            sparkTracker = sparksTracked
            print("Spark Tracker: ", sparkTracker)
        }
        
        let data = readFromFile(file: file)
        if (data != nil) {
            buildArray(data: data!)
//            derivedSparkArray = deriveSparks(array: sparkArray)
        }
        else {
            os_log("Data is nil", log: OSLog.sparkArrayBuilder, type: .info)
        }
    }
    
    func readFromFile(file: String) -> String! {
        guard let filePath = Bundle.main.path(forResource: file, ofType: "tsv") else {
                return nil
        }
        do {
            let fileContents = try String(contentsOfFile: filePath)
            return fileContents
        } catch {
            print("FILE READ ERROR (\(filePath)): \(error)")
            return nil
        }
    }
    
    /**
    Reads in a file and cleanses the data of any return characters or extra new line characters
    
    - Parameters:
       - file: A String representation of data
    */
    private func cleanData(file: String) -> String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    /**
     Reads in a files data in the form of a String. It breaks the data into rows and adds them to an array. It
     then separates the row arrays  into an array for each component within the row.
     
     - Parameters:
        - data: A String representation of data
     */
    
    func buildArray(data: String) {
        let sparkRow = cleanData(file: data).components(separatedBy: "\n")
        os_log("BUILDING ARRAY", log: OSLog.sparkArrayBuilder, type: .info)
        
        //For each new row created (array element), break up by tab delimiter and add to another array
        for row in sparkRow {
            
            if(!row.isEmpty) {
                //Derive spark component array and add to spark array
                let sparkComponents = row.components(separatedBy: "\t")
                
                sparkArray.append(sparkComponents)
                
    //            for component in sparkComponents {
                    print("ROW: \(row)")
    //            }
            }
            
        }
        
        os_log("Spark Array Count: %d", log: OSLog.viewController, type: .info, sparkArray.count)
        
        os_log("ARRAY COMPLETE", log: OSLog.sparkArrayBuilder, type: .info)
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
    
}

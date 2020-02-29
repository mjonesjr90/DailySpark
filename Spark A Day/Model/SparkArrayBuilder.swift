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

struct SparkArrayBuilder {

    var filePath: String?
    var sparkArray: [[String]] = []
    
    init(file: String) {
        let data = readFromFile(file: file)
        if (data != nil) {
            buildArray(data: data!)
        }
        else {
            os_log("Data is nil", log: OSLog.sparkArrayBuilder, type: .info)
        }
    }
    
    func readFromFile(file: String) -> String! {
        guard let filePath = Bundle.main.path(forResource: file, ofType: "txt") else {
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
    
    mutating func buildArray(data: String) {
        let sparkRow = cleanData(file: data).components(separatedBy: "\n")
        os_log(".....BUILDING ARRAY.....", log: OSLog.sparkArrayBuilder, type: .info)
        
        //For each new row created (array element), break up by tab delimiter and add to another array
        for row in sparkRow {
            print(row)
            
            //Derive spark component array and add to spark array
            let sparkComponents = row.components(separatedBy: "\t")
            sparkArray.append(sparkComponents)
            
            print(sparkComponents[1])
        }
    }
    
}

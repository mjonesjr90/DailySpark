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

struct SparkLogView: View {
    
    //User Defaults
    let defaults = UserDefaults.standard
    
    var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"
    
    var body: some View {
        List {
            Text("Spark1")
            Text("Spark2")
            Text("Spark3")
            Text("Spark4")
        }
    }
    
}

struct SparkLogView_Previews: PreviewProvider {
    static var previews: some View {
        SparkLogView()
    }
}

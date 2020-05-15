//
//  SparkLogView.swift
//  Spark A Day
//
//  Created by Malcom Jones on 3/1/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import SwiftUI
import os.log

struct SparkLogList: View {
    
     @EnvironmentObject var sab: SparkArrayBuilder
    
    //User Defaults
    let defaults = UserDefaults.standard
    
    @State var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"
    
    @State var beginDate: Date = Date()
    var beginDateKey = "BeginDateKey"
    
    @State var configured: Bool = false
    var configuredKey = "ConfiguredKey"
    
    @State var notificationHour: Int = 8
    var notificationHourKey = "notificationHourKey"
    
    @State var notificationMin: Int = 00
    var notificationMinKey = "notificationMinKey"
    
    //Formatting
    var dfs = DateFormatter()
    
    @State var sparkArray: [[String]] = []
    @State private var isPresented = false
    @State var sparkHeader : String = ""
    @State var sparkCategory: String = ""
    @State var sparkBody: String = ""
    
    init() {
        
        dfs.dateStyle = .short
        dfs.timeStyle = .short
        dfs.locale = .current
        
        
        if(!configured) {
            //Set begin date
            beginDate = Date()
            defaults.set(beginDate, forKey: beginDateKey)
        }
        
    }
    
    func update() {
        
        //Check what is saved in User Defaults
        os_log("Checking user defaults ...", log: OSLog.sparkList, type: .info)
        
        os_log("Checking if Configured", log: OSLog.sparkList, type: .info)
        if let isConfigured = defaults.object(forKey: configuredKey) as? Bool {
            configured = isConfigured
            print("Configured: ", configured)
        }

        os_log("Checking Begin Date", log: OSLog.sparkList, type: .info)
        if let dateBegan = defaults.object(forKey: beginDateKey) as? Date {
            beginDate = dateBegan
            print("Begin Date: ", dfs.string(from: beginDate))
        }

        os_log("Checking Spark Tracker", log: OSLog.sparkList, type: .info)
        if let sparksTracked = defaults.object(forKey: sparkTrackerKey) as? [String: String] {
            sparkTracker = sparksTracked
            print("Spark Tracker: ", sparkTracker)
        }

        os_log("Checking Notification Hour", log: OSLog.sparkList, type: .info)
        if let notHour = defaults.object(forKey: notificationHourKey) as? Int {
            notificationHour = notHour
            print("Notification Hour: ", notificationHour)
        }

        os_log("Checking Notification Minute", log: OSLog.sparkList, type: .info)
        if let notMin = defaults.object(forKey: notificationMinKey) as? Int {
            notificationMin = notMin
            print("Notification Min: ", notificationMin)
        }
        
        //Update array
        os_log("Set new Spark Array", log: OSLog.sparkList, type: .info)
        sab.derivedSparkArray = deriveSparks(array: sab.sparkArray)
        
        //Use array to schedule notifications
       os_log("Spark List Count: %d", log: OSLog.sparkList, type: .info, sab.sparkArray.count)
       var sb = SparkBuilder(array: sab.sparkArray)
        //Initial scheduling should only occur if this is the first time the app
        //is opened or if the user decides to reset the notifications
        if(!configured) {
            sb.scheduleNotifications()
        }
//        if(configured) {
//            sb.cleanSparkTracker()
//
//            //Resechedule
//            sb.scheduleNotifications()
//        }
    }
    
    var body: some View {
        NavigationView {
            List (sab.derivedSparkArray.sorted(by: {
                 ($0[1]) < ($1[1])
            }), id: \.self) { spark in
                NavigationLink(destination: SparkLogDetail(sparkHeader: spark[1], sparkCategory: spark[0], sparkBody: spark[3], show: .constant(true))) {
                    SparkLogRow(spark: spark)
                }
            }
            .navigationBarTitle(Text("Sparks"))
            .navigationBarItems(trailing:
                NavigationLink(destination: AnyView(MenuView())) {
                    Image(systemName: "bell.fill")
                        .imageScale(.small)
                        .font(Font.title.weight(.regular))
                        .foregroundColor(.orange)
                }
            )
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                print("Moving back to the foreground!")
                
                self.update()
               
            }
            .onAppear(perform: {
                print("SparkList onAppear")
                
                self.update()
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "notificationSelected"), object: nil, queue: .main) { (Notification) in
                    
                    self.isPresented = true
                    self.update()
                    
                    os_log("Pulling data from notification ...", log: OSLog.sparkList, type: .info)
                    if let title = Notification.userInfo?["title"] as? String {
                        os_log("title: %s", log: OSLog.sparkList, type: .info, title)
                        self.sparkHeader = title
                    }
                    
                    if let body = Notification.userInfo?["longBody"] as? String {
                        os_log("body: %s", log: OSLog.sparkList, type: .info, body)
                        self.sparkBody = body
                    }
                }
            })
            .sheet(isPresented: $isPresented) {
                
                SparkLogDetail(sparkHeader: self.sparkHeader, sparkCategory: "", sparkBody: self.sparkBody, show: self.$isPresented)
            }
        }
        .accentColor( .orange)
    }
    
    func deriveSparks(array: [[String]]) -> [[String]] {
        //Read in full spark array list
        //Pull out Spark IDs from spark tracker that have passed using current date vs begin date into array
        //Use this new array to determine which sparks from the full array to return
        
        os_log("Deriving sparks ...", log: OSLog.sparkList, type: .info)
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
    
    mutating func notificationSelected(notification: NSNotification) {
        os_log("Pulling data from notification ...", log: OSLog.sparkList, type: .info)
        if let title = notification.userInfo?["title"] as? String {
            os_log("title: %s", log: OSLog.sparkList, type: .info, title)
            self.sparkHeader = title
        }
        
        if let body = notification.userInfo?["longBody"] as? String {
            os_log("body: %s", log: OSLog.sparkList, type: .info, body)
            self.sparkBody = body
        }
    }
}


struct SparkLogList_Previews: PreviewProvider {
    static var previews: some View {
        SparkLogList().environmentObject(SparkArrayBuilder(file: "sparks"))
    }
}

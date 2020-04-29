//
//  MainView.swift
//  Spark A Day
//
//  Created by Malcom Jones on 4/28/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import SwiftUI
import UserNotifications
import os

struct MainView: View {
    
    @State private var isPresented = false
    @State var sparkHeader : String = ""
    @State var sparkCategory: String = ""
    @State var sparkBody: String = ""
    
    var body: some View {
        ZStack {
            NavigationLink(destination: SparkLogDetail(sparkHeader: sparkHeader, sparkCategory: "", sparkBody: sparkBody, show: self.$isPresented), isActive: self.$isPresented) {
                Text("")
            }
            ViewControllerWrapper()
        }.onAppear {
            print("Open ViewControllerWrapper")
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "notificationSelected"), object: nil, queue: .main) { (Notification) in
                self.isPresented = true
                os_log("Pulling data from notification ...", log: OSLog.viewController, type: .info)
                if let title = Notification.userInfo?["title"] as? String {
                    os_log("title: %s", log: OSLog.viewController, type: .info, title)
                    self.sparkHeader = title
                }
                
                if let body = Notification.userInfo?["longBody"] as? String {
                    os_log("body: %s", log: OSLog.viewController, type: .info, body)
                    self.sparkBody = body
                }
            }
        }
         
    }
    
    mutating func notificationSelected(notification: NSNotification) {
        os_log("Pulling data from notification ...", log: OSLog.viewController, type: .info)
        if let title = notification.userInfo?["title"] as? String {
            os_log("title: %s", log: OSLog.viewController, type: .info, title)
            self.sparkHeader = title
        }
        
        if let body = notification.userInfo?["longBody"] as? String {
            os_log("body: %s", log: OSLog.viewController, type: .info, body)
            self.sparkBody = body
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

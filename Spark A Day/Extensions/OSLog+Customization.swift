//
//  OSLog+Customization.swift
//  Spark A Day
//
//  Created by Malcom Jones on 2/25/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import os.log

extension OSLog {
    //Get app bundle as a string
    private static var bundle = Bundle.main.bundleIdentifier!
    
    //Create OSLog categories
    static let sparkBuilder = OSLog(subsystem: bundle, category: "sparkBuilder")
    static let sparkArrayBuilder = OSLog(subsystem: bundle, category: "sparkArrayBuilder")
    static let viewController = OSLog(subsystem: bundle, category: "viewController")
    static let notificationConfig = OSLog(subsystem: bundle, category: "notificationConfig")
   
}


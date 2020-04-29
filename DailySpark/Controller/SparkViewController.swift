//
//  SparkViewController.swift
//  Spark A Day
//
//  Created by Malcom Jones on 4/23/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import os

class SparkViewController: UIViewController {

    //UI
    @IBOutlet weak var sparkHeader: UILabel!
    @IBOutlet weak var sparkBody: UILabel!
    
    var sparkHeaderHolder: String = ""
    var sparkCategoryHolder: String = ""
    var sparkBodyHolder: String = ""
    
    //User Defaults
    let defaults = UserDefaults.standard
    
    var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"
    
    var beginDate: Date?
    var beginDateKey = "BeginDateKey"
    
    var configured: Bool = false
    var configuredKey = "ConfiguredKey"
    
    var notificationHour: Int?
    var notificationHourKey = "notificationHourKey"
    
    var notificationMin: Int?
    var notificationMinKey = "notificationMinKey"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        os_log("viewWillAppear", log: OSLog.sparkViewController, type: .info)
        updateUI()
    }
    
    func updateUI() {
        os_log("updateUI", log: OSLog.sparkViewController, type: .info)
        os_log("sparkHeaderHolder: %s", log: OSLog.sparkViewController, type: .info, sparkHeaderHolder)
        os_log("sparkBodyHolder: %s", log: OSLog.sparkViewController, type: .info, sparkBodyHolder)
        sparkHeader.text = sparkHeaderHolder
        sparkBody.text = sparkBodyHolder
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

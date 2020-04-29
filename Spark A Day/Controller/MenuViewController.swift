//
//  MenuViewController.swift
//  Spark A Day
//
//  Created by Malcom Jones on 4/21/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import os

class MenuViewController: UIViewController {

    //User Defaults
    let defaults = UserDefaults.standard
    
    var notificationHour: Int?
    var notificationHourKey = "notificationHourKey"
    
    var notificationMin: Int?
    var notificationMinKey = "notificationMinKey"
    
    var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"

    var beginDate: Date?
    var beginDateKey = "BeginDateKey"

    var configured: Bool = false
    var configuredKey = "ConfiguredKey"
    
    @IBOutlet weak var notificationTimeTextField: UITextField!
    private var timePicker: UIDatePicker?
    @IBOutlet var menuView: UIView!
    var dfs = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dfs.timeStyle = .short
        
        checkUserDefaults()
        
        timePicker = UIDatePicker()
        timePicker?.calendar = Calendar.current
        timePicker?.datePickerMode = .time
        timePicker?.addTarget(self, action: #selector(MenuViewController.timeChanged(timePicker:)), for: .valueChanged)
        
        let date = Calendar.current.date(from: DateComponents(calendar: Calendar.current, hour: notificationHour, minute: notificationMin))
        
        notificationTimeTextField.text = dfs.string(from: date!)
        notificationTimeTextField.addTarget(self, action: #selector(MenuViewController.timeSelected(textField:)), for: .editingDidBegin)
        notificationTimeTextField.inputView = timePicker
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(screenTapped))
        menuView.addGestureRecognizer(tap)
    }
    
    @objc func screenTapped() {
        view.endEditing(true)
        
        defaults.set(notificationHour, forKey: notificationHourKey)
        defaults.set(notificationMin, forKey: notificationMinKey)
        
        //Resechedule notifications that haven't been sent yet, up to 64 max if applicable
        //Build array from file
        let sab = SparkArrayBuilder(file: "sparks")
        
        //Use array to schedule notifications
        os_log("Spark List Count: %d", log: OSLog.menuViewController, type: .info, sab.sparkArray.count)
        var sb = SparkBuilder(array: sab.sparkArray)
        sb.cleanSparkTracker()
        
        //Resechedule
        sb.scheduleNotifications()
    }
    
    @objc func timeSelected(textField: UITextField) {
        let date = dfs.date(from: textField.text!)!
        timePicker!.setDate(date, animated: true)
    }
    
    @objc func timeChanged(timePicker: UIDatePicker) {
        notificationHour = Calendar.current.component(.hour, from: timePicker.date)
        notificationMin = Calendar.current.component(.minute, from:  timePicker.date)
        
        notificationTimeTextField.text = dfs.string(from: timePicker.date)
    }
    
    func checkUserDefaults(){
        os_log("Checking user defaults ...", log: OSLog.menuViewController, type: .info)
       
        os_log("Checking if Configured", log: OSLog.menuViewController, type: .info)
        if let isConfigured = defaults.object(forKey: configuredKey) as? Bool {
            configured = isConfigured
            print("Configured: ", configured)
        }
        
        os_log("Checking Begin Date", log: OSLog.menuViewController, type: .info)
        if let dateBegan = defaults.object(forKey: beginDateKey) as? Date {
            beginDate = dateBegan
            print("Begin Date: ", dfs.string(from: beginDate!))
        }
        
        os_log("Checking Spark Tracker", log: OSLog.menuViewController, type: .info)
        if let sparksTracked = defaults.object(forKey: sparkTrackerKey) as? [String: String] {
            sparkTracker = sparksTracked
            print("Spark Tracker: ", sparkTracker)
        }
        
        os_log("Checking Notification Hour", log: OSLog.menuViewController, type: .info)
        if let notHour = defaults.object(forKey: notificationHourKey) as? Int {
            notificationHour = notHour
        } else {
            notificationHour = 8
        }
        print("Notification Hour: ", notificationHour!)
        
        os_log("Checking Notification Minute", log: OSLog.menuViewController, type: .info)
        if let notMin = defaults.object(forKey: notificationMinKey) as? Int {
            notificationMin = notMin
        } else {
            notificationMin = 00
        }
        print("Notification Min: ", notificationMin!)
    }
    
    @IBAction func resetSparks(_ sender: Any) {
        let alertController = UIAlertController(title: "Reset Sparks", message: "This will reset all of your Sparks. Your Spark Log will be deleted and notifications will start from scratch. Do you want to continue?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: {(UIAlertAction) in
            self.sparkTracker = [:]
            self.defaults.set(self.sparkTracker, forKey: self.sparkTrackerKey)
            
            self.beginDate = Date()
            self.defaults.set(self.dfs.string(from: self.beginDate!), forKey: self.beginDateKey)
            
            self.configured = false
            self.defaults.set(self.configured, forKey: self.configuredKey)
            
            self.notificationHour = 8
            self.defaults.set(self.notificationHour, forKey: self.notificationHourKey)
            
            self.notificationMin = 00
            self.defaults.set(self.notificationMin, forKey: self.notificationMinKey)
            
            //Reconfigure from scratch
            //Build array from file
            let sab = SparkArrayBuilder(file: "sparks")
            
            //Use array to schedule notifications
            os_log("Spark List Count: %d", log: OSLog.menuViewController, type: .info, sab.sparkArray.count)
            var sb = SparkBuilder(array: sab.sparkArray)
            sb.scheduleNotifications()
        })
        let noAction = UIAlertAction(title: "No", style: .default, handler: {(UIAlertAction) in
        })
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

     @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
     }
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SparkTableViewController.swift
//  Spark A Day
//
//  Created by Malcom Jones on 3/1/20.
//  Copyright © 2020 Malcom Jones. All rights reserved.
//

import UIKit
import UserNotifications
import os.log

class SparkTableViewController: UITableViewController {

    //User Defaults
    let defaults = UserDefaults.standard
    
    var sparkTracker: [String:String] = [:]
    var sparkTrackerKey = "SparkTrackerKey"
    
    var beginDate: Date?
    var beginDateKey = "BeginDateKey"
    
    var sparkArray: [[String]] = []
    
    var dfs = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dfs.dateStyle = .short
        dfs.timeStyle = .short
        dfs.locale = .current

        checkUserDefaults()
        
        //Build array from file
        let sab = SparkArrayBuilder(file: "sparks")
        sparkArray = deriveSparks(array: sab.sparkArray)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    // MARK: - Table view data source
    func checkUserDefaults(){
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        //Use one section to show one list
//        var numOfSections: Int = 0
//        if youHaveData
//        {
//            tableView.separatorStyle = .singleLine
//            numOfSections            = 1
//            tableView.backgroundView = nil
//        }
//        else
//        {
//            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
//            noDataLabel.text          = "No data available"
//            noDataLabel.textColor     = UIColor.black
//            noDataLabel.textAlignment = .center
//            tableView.backgroundView  = noDataLabel
//            tableView.separatorStyle  = .none
//        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sparkArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "SparkTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SparkTableViewCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
//        if(sparkArray.count > 0) {
            let spark = sparkArray[indexPath.row]
            
            cell.primaryLabel.text = spark[1]
            cell.categoryLabel.text = spark[0]
//        }

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let spark = sparkArray[indexPath.row]
        
        if let viewController = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {
            viewController.titleLabelHolder = spark[1]
            viewController.bodyLabelHolder = spark[3]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

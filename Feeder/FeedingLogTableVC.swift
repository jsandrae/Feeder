//
//  FeedingLog.swift
//  Feeder
//
//  Created by Jason Andrae on 3/30/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//
//  Code reference:
//  https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html#//apple_ref/doc/uid/TP40015214-CH14-SW1
//

import UIKit

class FeedingLogTableVC: UITableViewController {
    
    // MARK: Properties
    var feedings = [FeedingModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedFeedings = loadFeedings(){
            feedings += savedFeedings
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FeedingLogTableCell"
        
        // Downcast cell to created table cell class
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FeedingLogCell

        // Get correct log cell for this index in table
        let log = feedings[indexPath.row]
        
        // Update labels in cell
        cell.date.text = log.date
        cell.user.text = log.user

        return cell
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Returning false to prevent users from editing informational table
        return false
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Returning false to prevent users from explicitly rearranging table
        return false
    }

    /*
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: getJSON
    
    // MARK NSCoding
    func saveFeedings(){
        let isSucessfulSave = NSKeyedArchiver.archiveRootObject(feedings, toFile: FeedingModel.ArchiveURL.path!)
        if !isSucessfulSave {
            print("failed to save feedings")
        }
    }
    
    func loadFeedings() -> [FeedingModel]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(FeedingModel.ArchiveURL.path!) as? [FeedingModel]
    }

}

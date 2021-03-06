//
//  FeedingLogTableVC.swift
//  Feeder
//
//  Created by Jason Andrae on 3/30/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//
//  Code reference:
//  https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html#//apple_ref/doc/uid/TP40015214-CH14-SW1,
//  Ken Toh: https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started
//

import UIKit

class FeedingLogTableVC: UITableViewController {
    
    // MARK: Properties
    var feedings = [FeedingModel]()
    var login: LoginModel?
    let currentSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedFeedings = loadFeedings(){
            feedings += savedFeedings
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let tabBarVC = self.tabBarController as! FeedingTabBarVC
        login = tabBarVC.tabLogin
        getLog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FeedingLogTableCell"
        
        // Downcast cell to created table cell class
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FeedingLogCell

        // Get correct log cell for this index in table
        let log = feedings[(indexPath as NSIndexPath).row]
        
        // Update labels in cell
        cell.date.text = log.date
        cell.user.text = log.user

        return cell
    }
 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Returning false to prevent users from editing informational table
        return false
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Returning false to prevent users from explicitly rearranging table
        return false
    }
    
    // MARK: Actions
    @IBAction func dismissView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: getLog
    func getLog(){
        // Display network activity monitor to show user process is working
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let urlString:String = "http://"+login!.url + "/log"
        print(urlString)
        let url = URL(string: urlString)
        // Assign data task to this session, pass saved url, perform callback handler
        dataTask = currentSession.dataTask(with: url!, completionHandler: {
            data, response, error in
            // Dismiss network activity monitor once asynchronous response received
            DispatchQueue.main.async {
                // if error returned, print error
                if let receivedError = error {
                    print (receivedError.localizedDescription)
                    self.title = "Network Error"
                } else if let httpResponse = response as? HTTPURLResponse {
                    // If received positive response, parse data
                    if httpResponse.statusCode == 200 {
                        self.title = "Feeding Log"
                        let feedingLog = self.parseJSON(data!)
                        self.feedings = feedingLog
                    }
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.tableView.reloadData()
            }
        })
        // Since tasks begin in a suspended state, start task
        dataTask?.resume()
    }
    
    func parseJSON(_ data:Data) -> [FeedingModel]{
        var feedingLog = [FeedingModel]()
        // Parse data and store in dictionary
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let entries = json["log"] as? [[String:AnyObject]] {
                for entry in entries {
                    if let timestamp = entry["timestamp"] as? String {
                        if let username = entry["username"] as? String {
                            feedingLog.append(FeedingModel(username: username, date: timestamp)!)
                        }
                    }
                }
            }
        } catch{
            print("Error with JSON: \(error)")
        }
        return feedingLog
    }
    
    // MARK NSCoding
    func saveFeedings(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(feedings, toFile: FeedingModel.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("failed to save feedings")
        }
    }
    
    func loadFeedings() -> [FeedingModel]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: FeedingModel.ArchiveURL.path!) as? [FeedingModel]
    }

}

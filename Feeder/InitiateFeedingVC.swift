//
//  InitiateFeedingVC.swift
//  Feeder
//
//  Created by Jason Andrae on 3/31/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import UIKit

class InitiateFeedingVC: UIViewController {
    
    // MARK: Properties
    let currentSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var login: LoginModel?
    var dataTask: NSURLSessionDataTask?
    
    @IBOutlet weak var feedbackLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(login)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func feedButton(sender: UIButton) {
        // Display network activity monitor to show user process is working
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let url = NSURL(string: login!.url)
        // Assign data task to this session, pass saved url, perform callback handler
        dataTask = currentSession.dataTaskWithURL(url!){
            data, response, error in
            // Dismiss network activity monitor once asynchronous response received
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            // if error returned, print error
            if let receivedError = error {
                print (receivedError.localizedDescription)
                self.feedbackLabel.text = "Uh oh, something went wrong. \rTry again in a few minutes."
            } else if let httpResponse = response as? NSHTTPURLResponse {
                // If received positive response, update label to relay info to user
                if httpResponse.statusCode == 200 {
                    self.feedbackLabel.text = "Sucessful feeding. Dog is grateful"
                }
            }
        }
        // Since tasks begin in a suspended state, start task
        dataTask?.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
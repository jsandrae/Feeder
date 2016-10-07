//
//  InitiateFeedingVC.swift
//  Feeder
//
//  Created by Jason Andrae on 3/31/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//
//  Code reference:
//  Ken Toh: https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started
//

import UIKit

class InitiateFeedingVC: UIViewController {
    
    // MARK: Properties
    let currentSession = URLSession(configuration: URLSessionConfiguration.default)
    var login: LoginModel?
    var dataTask: URLSessionDataTask?
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var feedingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarVC = self.tabBarController as! FeedingTabBarVC
        login = tabBarVC.tabLogin
    }
    
    // Adding these functions to DidAppear allows view to be reset upon return
    override func viewDidAppear(_ animated: Bool) {
        feedingButton.isEnabled = true
        feedbackLabel.text = "It's time"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func feedButton(_ sender: UIButton) {
        // Display network activity monitor to show user process is working
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.feedbackLabel.text = "Feeding sent, waiting on response"
        feedingButton.isEnabled = false
        // Concat path and username to given feeder URL
        let urlString:String = "http://"+login!.url + "/feed/" + login!.username
        print(urlString)
        let url = URL(string: urlString)
        // Assign data task to this session, pass saved url, perform callback handler
        dataTask = currentSession.dataTask(with: url!, completionHandler: {
            data, response, error in
            // Dismiss network activity monitor once asynchronous response received
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                // if error returned, print error
                if let receivedError = error {
                    print (receivedError.localizedDescription)
                    self.feedbackLabel.text = "Uh oh, something went wrong. \rTry again in a few minutes."
                } else if let httpResponse = response as? HTTPURLResponse {
                    // If received positive response, update label to relay info to user
                    if httpResponse.statusCode == 200 {
                        self.feedbackLabel.text = "Successful feeding. \rMaesy is grateful."
                        self.feedingButton.isEnabled = true
                        self.feedingButton.setTitle("Feed again?", for: UIControlState())
                    }
                }
            }
        })
        // Since tasks begin in a suspended state, start task
        dataTask?.resume()
    }
    
    @IBAction func dismissCurrentView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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

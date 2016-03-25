//
//  WelcomeVC.swift
//  Feeder
//
//  Created by Jason Andrae on 3/21/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import UIKit
import CoreData

class WelcomeVC: UIViewController {

    // MARK: Properties
    @IBOutlet weak var usernameLabel: UILabel!
    
    var username: String?
    var isAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide view until return from login view
        view.alpha = 0
        
        // Try to load a saved login
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        // No login present, goto login view
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as? String
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    // Logout button action
    @IBAction func logoutTapped(sender: UIButton) {
        self.performSegueWithIdentifier("gotoLogin", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: NSCoding
    func loadLogin() -> Login? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Login.ArchiveURL.path!) as? Login
    }

}

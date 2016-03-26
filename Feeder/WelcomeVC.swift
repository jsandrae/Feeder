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
    var didReturnFromBackground = false
    
    // MARK: Loading Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide view until return from login view
        view.alpha = 0
        
        
    }
    
    func appWillResignActive(notification : NSNotification) {
        
        view.alpha = 0
        isAuthenticated = false
        didReturnFromBackground = true
    }
    
    func appDidBecomeActive(notification : NSNotification) {
        
        if didReturnFromBackground {
            self.showLoginView()
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(false)
        self.showLoginView()
    }
    
    func showLoginView() {
        
        if !isAuthenticated {
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

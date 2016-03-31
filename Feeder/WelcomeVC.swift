//
//  WelcomeVC.swift
//  Feeder
//
//  Created by Jason Andrae on 3/21/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import UIKit
import CoreData

class WelcomeVC: UIViewController, NSFetchedResultsControllerDelegate {

    // MARK: Properties
    var isAuthenticated = false
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    var didReturnFromBackground = false
    
    // Buttons and Lables
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    // Properties
    
    
    // Objects
    var login: LoginModel?
    var username: String?
    
    // MARK: Loading Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide view until return from login view
        view.alpha = 0
        
        /*
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "HungryDog")
        self.view.insertSubview(backgroundImage, atIndex: 0)

        let bImage = UIImage(named: "HungryDog")
        let bImageView = UIImageView(image: bImage)
        self.view.addSubview(bImageView)*/
    }
    
    /**
     * Function for response to user returning to home screen on phone
     */
    func appWillResignActive(notification : NSNotification) {
        view.alpha = 0
        isAuthenticated = false
        didReturnFromBackground = true
    }
    
    /**
     * Function for app regaining focus on phone
     */
    func appDidBecomeActive(notification : NSNotification) {
        if didReturnFromBackground {
            self.showLoginView()
        }
    }
    
    /**
     * Function for when App first loads
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        self.showLoginView()
    }

    /**
     * Function for app to receive signal to reduce memory footprint
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Set variable in destination VC which signifies this segue's identifier
        let segueID = segue.identifier!
        if segueID == "editSettings" {
            let nav = segue.destinationViewController as! UINavigationController
            (nav.topViewController as! LoginViewController).segueID = segueID
        } else if segueID == "gotoLogin" {
            (segue.destinationViewController as! LoginViewController).segueID = segueID
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        isAuthenticated = true
        view.alpha = 1.0
        usernameLabel.text = "the Dog \(login!.username)!"
    }
    
    // MARK: Helper Functions
    /**
     * Function for checking for checking authentication
     */
    func showLoginView() {
        if !isAuthenticated {
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        }
    }

}

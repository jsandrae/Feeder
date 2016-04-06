//
//  WelcomeVC.swift
//  Feeder
//
//  Created by Jason Andrae on 3/21/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//
//  Some code heavily modified from Tim Mitra: https://www.raywenderlich.com/92667/securing-ios-data-keychain-touch-id-1password
//  https://developer.apple.com/library/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson10.html#//apple_ref/doc/uid/TP40015214-CH14-SW1,

import UIKit
import CoreData

class WelcomeVC: UIViewController, NSFetchedResultsControllerDelegate {

    // MARK: Properties
    var isAuthenticated = false
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    var didReturnFromBackground = false
    
    // Buttons and Labels
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dogPhoto: UIImageView!
    
    // Objects
    var login: LoginModel?
    var username: String?
    
    // MARK: Loading Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide view until return from login view
        view.alpha = 0
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
     * Function for anytime view is displayed
     */
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(false)
        self.showLoginView()
        showMaesy()
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
        } else { // Go to tab bar
            let tabBar = segue.destinationViewController as! FeedingTabBarVC
            tabBar.tabLogin = login
            if segueID == "gotoInitiate" {
                let nav = tabBar.viewControllers![1] as! UINavigationController
                tabBar.selectedViewController = nav
            } else if segueID == "gotoFeedingLog" {
                let nav = tabBar.viewControllers![2] as! UINavigationController
                tabBar.selectedViewController = nav
            }
        }
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        if segue.identifier == "resetData"{
            // 
        } else {
            isAuthenticated = true
            view.alpha = 1.0
            usernameLabel.text = "the Dog \(login!.username)!"
        }
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
    
    /**
     * Function to randomly add an image to imageView
     */
    func showMaesy() {
        // Create array of image names
        let pictureList = [
            "Bouncer",
            "DerpDog",
            "HappyDog",
            "HungryDog",
            "LongingDog",
            "ShaggyDog"
        ]
        
        let randInt = Int(arc4random_uniform(UInt32(pictureList.count)))
        dogPhoto.image = UIImage(named: pictureList[randInt])
    }

}

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

class WelcomeVC: UIViewController, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    var dogSavedDogPhoto: UIImage?
    
    // MARK: Loading Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide view until return from login view
        view.alpha = 0
    }
    
    /**
     * Function for response to user returning to home screen on phone
     */
    func appWillResignActive(_ notification : Notification) {
        view.alpha = 0
        isAuthenticated = false
        didReturnFromBackground = true
    }
    
    /**
     * Function for app regaining focus on phone
     */
    func appDidBecomeActive(_ notification : Notification) {
        if didReturnFromBackground {
            self.showLoginView()
        }
    }
    
    /**
     * Function for anytime view is displayed
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        self.showLoginView()
        if let image = dogSavedDogPhoto {
            dogPhoto.image = image
        } else {
            showMaesy()
        }
    }

    /**
     * Function for app to receive signal to reduce memory footprint
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    @IBAction func photoTapped(_ sender: UITapGestureRecognizer) {
        print("photo tapped")
        // Programmatically create an image picker controller to allow users to select a photo from their library
        let imagePickerController = UIImagePickerController()
        
        // Allow pictures to only be selected from user's photo library
        imagePickerController.sourceType = .photoLibrary
        
        // Designate WelcomeVC to control this view
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    /**
     * Function to control the presentation of the photo library selector and saving the new photo
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Use original photo from the photo library
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set the photo image view to the selected image
        dogSavedDogPhoto = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Set variable in destination VC which signifies this segue's identifier
        let segueID = segue.identifier!
        if segueID == "editSettings" {
            let nav = segue.destination as! UINavigationController
            (nav.topViewController as! LoginViewController).segueID = segueID
        } else if segueID == "gotoLogin" {
            (segue.destination as! LoginViewController).segueID = segueID
        } else { // Go to tab bar
            let tabBar = segue.destination as! FeedingTabBarVC
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
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue){
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
            self.performSegue(withIdentifier: "gotoLogin", sender: self)
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

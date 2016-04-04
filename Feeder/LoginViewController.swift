//
//  LoginViewController.swift
//  Feeder
//
//  Created by Jason Andrae on 3/13/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//  Some code heavily modified from Tim Mitra: https://www.raywenderlich.com/92667/securing-ios-data-keychain-touch-id-1password
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {

    // MARK: Properties
    
    // Text Fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    // Button and Labels
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    
    // State of loginButton (Login or Create)
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    let settingsButtonTag = 2
    
    // Keychain wrapper
    let MyKeychainWrapper = KeychainWrapper()
    
    // Variables
    var myLogin: LoginModel?
    var isAuthenticated = false
    var managedObjectContext: NSManagedObjectContext? = nil
    var segueID: String?
    
    // Aliases
    let settingsA = "editSettings"
    let loginA = "gotoLogin"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // If account loaded, store username in text field as convenience factor
        if !isSetup() {
            myLogin = loadLogin()
            nameTextField.text = myLogin?.username
        }
        
        // Hide reset button for all views but settings
        resetButton.hidden = true
        
        // If logging in
        if isLogin() {
            // Change button attributes
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            loginButton.tag = loginButtonTag
            // Hide text fields
            confirmTextField.hidden = true
            urlTextField.hidden = true
            // Change label text
            createInfoLabel.text = "Log in with username and password"
            isAuthenticated = true
            updateName()
        } else { // Else, change button to create account, unhide account creation label
            // Change button attributes
            loginButton.setTitle("Create", forState: UIControlState.Normal)
            loginButton.tag = createLoginButtonTag
            // Change text field return key
            passTextField.returnKeyType = UIReturnKeyType.Next
            // Change label text
            createInfoLabel.text = "Create username and password. \rSpecify feeder's URL."
        }
        
        // Change state for settings edit
        if isSettings() {
            // Hide button, disable save
            loginButton.setTitle("Update Account", forState: UIControlState.Normal)
            loginButton.enabled = false
            // Change informational text
            createInfoLabel.text = "Edit any field you wish to change."
            urlTextField.text = myLogin!.url
            updateName()
            resetButton.hidden = false
        }
        
        
        // If creating account, set user as default text field, else password
        if isSetup() {
            nameTextField.becomeFirstResponder()
        } else {
            // Set password text field as default text field on load
            passTextField.becomeFirstResponder()
        }
        
        // Set up view controller to be own text field delegates
        nameTextField.delegate = self
        passTextField.delegate = self
        confirmTextField.delegate = self
        urlTextField.delegate = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextFieldDelegate
    /**
     * Function for what happens when enter key is used for a given text field
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        
        switch textField {
        case nameTextField:
            passTextField.becomeFirstResponder()
            updateName()
        case passTextField:
            if isLogin() {// Go to login
                break
            } else {// If no authentication exists, continue to signup
                confirmTextField.becomeFirstResponder()
            }
        case confirmTextField:
            urlTextField.becomeFirstResponder()
        case urlTextField:
            break
        default:
            print("something has gone wrong")
        }
        return true
    }
    
    /** 
     * Function to perform actions after a text field has ended entry
     */
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidInputs()
    }
    
    /**
     * Function to disable login button until all text fields have been entered
     */
    func textFieldDidBeginEditing(textField: UITextField) {
        loginButton.enabled = false
    }
    
    // MARK: Actions
    
    @IBAction func userTapped(sender: UITapGestureRecognizer) {
        removeAllResponders()
        checkValidInputs()
    }

    
    @IBAction func loginAction(sender: UIButton) {
        removeAllResponders()
        let isValid = textFieldIsFull(true)
        if isValid {
            performLogin()
        }
    }
    
    @IBAction func resetData(sender: UIButton) {
        // Remove UserDefault data
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        // Removed other saved object data
        let filePaths = [LoginModel.ArchiveURL.path!, FeedingModel.ArchiveURL.path!] // Array of all current model objects to allow for easy future additions
        for path in filePaths {
            let exists = NSFileManager.defaultManager().fileExistsAtPath(path)
            if exists {
                do {
                    try NSFileManager.defaultManager().removeItemAtPath(path)
                }catch let error as NSError {
                    print("error: \(error.localizedDescription)")
                }
            }
        }
        // Remove Keychain data
        MyKeychainWrapper.mySetObject("", forKey:kSecValueData)
        MyKeychainWrapper.writeToKeychain()
        performSegueWithIdentifier("resetData", sender: self)
    }
    
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func performLogin(){
        
        // Find current status of button and perform actions depending on if it's create or login
        if isSetup() || isSettings() {
            
            // If changing data but pass and confirm don't match, bail
            if invalidTextField(){
                return
            }
            
            if isSettings() {
                let alertView = UIAlertController(title: "Update Settings", message: "Updating your settings will destroy all previous settings. \rAre you sure you wish to continue?", preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
                alertView.addAction(cancelAction)
                let updateAction = UIAlertAction(title: "Confirm", style: .Default, handler: confirmHelper)
                alertView.addAction(updateAction)
                
                // Support display in iPad
                alertView.popoverPresentationController?.sourceView = self.view
                alertView.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
                
                
                self.presentViewController(alertView, animated: true, completion: nil)
            } else {
                confirmChange()
            }
        } else if isLogin() { // else if login button
            // Compare typed user information to saved password in keychain
            if checkLogin(nameTextField.text!, password: passTextField.text!) {
                performSegueWithIdentifier("correctLogin", sender: self)
            } else {
                // Given password doesn't match saved password: clear pass text field and alert user
                passTextField.text = ""
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password." as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "I got this!", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
    
    
    
    // MARK: Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = (segue.destinationViewController as! WelcomeVC)
        destination.login = myLogin
        // If we reset the data, remove authentication flag
        if segue.identifier! == "resetData" {
            destination.isAuthenticated = false
        }
    }

    // MARK: Validation
    // Function to compare username for local login to given, and compare typed password to that saved on keychain
    func checkLogin(username: String, password: String ) -> Bool {
        // Compare entered username and passwords to keychain user and pass
        if password == MyKeychainWrapper.myObjectForKey("v_Data") as? String &&
            username == myLogin!.username {
            return true
        } else {
            return false
        }
    }
    
    /**
     * Function to test if all text fields are valid
     * @param Parameter for if text alerts are needed, but is false by default
     * @return Boolean value for if any text field is empty at function call
     */
    func textFieldIsFull(needAlert: Bool=false) -> Bool {
        // if either text field is empty, warn user with alert
        if (nameTextField.text == "" || passTextField.text == "") {
            if needAlert {
                let alertView = UIAlertController(title: "Input Problem",
                                                  message: "Username or password fields empty." as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            return false;
        }
        // If this is Settings View or Signup View and pass and confirm text fields don't match
        if isSetup() || isSettings() {
            if urlTextField.text == "" || confirmTextField.text == "" { // If URL text field is empty
                if needAlert {
                    let alertView = UIAlertController(title: "Signup Problem",
                                                      message: "URL Field Empty" as String, preferredStyle:.Alert)
                    let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
                    alertView.addAction(okAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                }
                return false;
            }
        }
        // All tests have succeeded, everything is valid
        return true
    }
    
    /**
     * Function to test if password and confirm password strings don't match
     */
    func invalidTextField() -> Bool {
        if passTextField.text != confirmTextField.text {
            let alertView = UIAlertController(title: "Signup Problem",
                                              message: "Passwords do not match" as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            passTextField.text = ""
            confirmTextField.text = ""
            return true
        }
        return false
    }
    
    // Function to disable save button unless all text fields are validly filled
    func checkValidInputs(){
        // If any text field is invalid, disable loginButton
        loginButton.enabled = textFieldIsFull()
    }
    
    // MARK: Helper Methods
    func removeAllResponders(){
        nameTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        confirmTextField.resignFirstResponder()
        urlTextField.resignFirstResponder()
    }
    
    func isLogin() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey("hasAccountKey") && segueID == loginA
    }
    
    func isSetup() -> Bool {
        let test = NSUserDefaults.standardUserDefaults().boolForKey("hasAccountKey")
        return !test && segueID == loginA
    }
    
    func isSettings() -> Bool {
        return segueID == settingsA
    }
    
    func updateName() {
        usernameLabel.text = "the Dog \(nameTextField.text!)!"
    }
    
    func confirmHelper(_:UIAlertAction){
        confirmChange()
    }
    
    func confirmChange() {
        // If setup, create new login with given information
        if isSetup() {
            myLogin = LoginModel(username: nameTextField.text!, url: urlTextField.text!)!
        } else {
            // Is settings change, just update login information
            myLogin!.username =  nameTextField.text!
            myLogin!.url = urlTextField.text!
        }
        saveLogin()
        
        // Store password in keychain for this user
        MyKeychainWrapper.mySetObject(passTextField.text, forKey:kSecValueData)
        MyKeychainWrapper.writeToKeychain()
        // Change state of login key to true and change button to login for future
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasAccountKey")
        NSUserDefaults.standardUserDefaults().synchronize()
        //loginButton.tag = loginButtonTag
        
        // Dismiss this view
        performSegueWithIdentifier("confirmComplete", sender: self)
    }
    
    // MARK: NSCoding
    func saveLogin(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(myLogin!, toFile: LoginModel.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("failed to save feedings")
        }
    }
    
    func loadLogin() -> LoginModel? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(LoginModel.ArchiveURL.path!) as? LoginModel
    }
}


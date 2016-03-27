//
//  LoginViewController.swift
//  Feeder
//
//  Created by Jason Andrae on 3/13/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
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
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // Button and Labels
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createInfoLabel: UILabel!
    
    // State of loginButton (Login or Create)
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    let settingsButtonTag = 2
    
    // Keychain wrapper
    let MyKeychainWrapper = KeychainWrapper()
    
    // Variables
    var login: Login?
    var isAuthenticated = false
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Load account from coredata
        let hasAccount = NSUserDefaults.standardUserDefaults().boolForKey("hasAccountKey")
        
        // If account exists
        if hasAccount {
            // Change button attributes
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            loginButton.tag = loginButtonTag
            // Hide text fields
            confirmTextField.hidden = true
            urlTextField.hidden = true
            // Change label text
            createInfoLabel.text = "Log in with username and password"
            isAuthenticated = true
        } else { // Else, change button to create account, unhide account creation label
            // Change button attributes
            loginButton.setTitle("Create", forState: UIControlState.Normal)
            loginButton.tag = createLoginButtonTag
            // Change text field return key
            passTextField.returnKeyType = UIReturnKeyType.Next
            // Change label text
            createInfoLabel.text = "Create username and password. \rSpecify feeder's URL."
        }
        
        // If account loaded, store username in text field as convenience factor
        if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
            nameTextField.text = storedUsername as String
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
            checkValidInputs()
        case passTextField:
            checkValidInputs()
            if isAuthenticated {// Go to login
                break
            } else {// If no authentication exists, continue to signup
                confirmTextField.becomeFirstResponder()
            }
        case confirmTextField:
            checkValidInputs()
            urlTextField.becomeFirstResponder()
        case urlTextField:
            checkValidInputs()
            break
        default:
            print("something has gone wrong")
        }
        return true
    }
    
    /**
     * Function to disable Save button until all text fields have been entered
     */
    func textFieldDidBeginEditing(textField: UITextField) {
        saveButton.enabled = false
    }
    
    // MARK: Actions
    
    @IBAction func loginAction(sender: UIButton) {
        nameTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
        performLogin(sender.tag)
    }
    
    func performLogin(senderID:Int){
        
        // if either text field is empty, warn user with alert
        if (nameTextField.text == "" || passTextField.text == "") {
            let alertView = UIAlertController(title: "Input Problem",
                                              message: "Username or password fields empty." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return;
        }
        
        // Find current status of button and perform actions depending on if it's create or login
        if senderID == createLoginButtonTag { // If create button
            
            // Check for text field errors
            if passTextField.text != confirmTextField.text {
                let alertView = UIAlertController(title: "Signup Problem",
                                                  message: "Passwords do not match" as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                passTextField.text = ""
                confirmTextField.text = ""
                return;
            } else if urlTextField.text == "" {
                let alertView = UIAlertController(title: "Signup Problem",
                                                  message: "URL Field Empty" as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
                return;
            }
            
            // If user doesn't have local login key, add username to local status object
            let hasAccountKey = NSUserDefaults.standardUserDefaults().boolForKey("hasAccountKey")
            if hasAccountKey == false {
                NSUserDefaults.standardUserDefaults().setValue(self.nameTextField.text, forKey: "username")
                NSUserDefaults.standardUserDefaults().setValue(self.urlTextField.text, forKey: "url")
            }
            
            // Store password in keychain for this user
            MyKeychainWrapper.mySetObject(passTextField.text, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            // Change state of login key to true and change button to login for future
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasAccountKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            loginButton.tag = loginButtonTag
            
            // Dismiss this view
            performSegueWithIdentifier("dismissLogin", sender: self)
        } else if senderID == loginButtonTag { // elseif login button
            // Compare typed user information to saved password in keychain
            if checkLogin(nameTextField.text!, password: passTextField.text!) {
                performSegueWithIdentifier("dismissLogin", sender: self)
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
        if saveButton === sender {
            login = Login(username: nameTextField.text!, url: urlTextField.text!)
        }
    }
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    // MARK: Helper functions
    // Function to compare username for local login to given, and compare typed password to that saved on keychain
    func checkLogin(username: String, password: String ) -> Bool {
        // Compare entered username and passwords to keychain user and pass
        if password == MyKeychainWrapper.myObjectForKey("v_Data") as? String &&
            username == NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
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
    func textFieldIsValid(needAlert: Bool=false) -> Bool {
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
        if (!isAuthenticated && passTextField.text != confirmTextField.text) {
            if needAlert {
                let alertView = UIAlertController(title: "Signup Problem",
                                                  message: "Passwords do not match" as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            passTextField.text = ""
            confirmTextField.text = ""
            return false;
        // If URL text field is empty
        } else if urlTextField.text == "" {
            if needAlert {
                let alertView = UIAlertController(title: "Signup Problem",
                                                  message: "URL Field Empty" as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
            return false;
        }
        // All tests have suceeded, everything is valid
        return true
    }
    
    // Function to disable save button unless all text fields are validly filled
    func checkValidInputs(){
        // If any text field is invalid, disable saveButton
        saveButton.enabled = !textFieldIsValid()
    }
}


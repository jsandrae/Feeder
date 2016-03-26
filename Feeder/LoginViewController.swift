//
//  LoginViewController.swift
//  Feeder
//
//  Created by Jason Andrae on 3/13/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import UIKit

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
    
    // State of loginButton (Login or Create)
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    // Keychain wrapper
    let MyKeychainWrapper = KeychainWrapper()
    
    // Variables
    var login: Login?
    var givenUser: String?
    var givenPass: String?
    var givenConfirm: String?
    var givenURL: String?
    var isAuthenticated = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Load account from keychain
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
    
    // MARK: UITextFieldDelegate
    /**
     * Function for what happens when enter key is used for a given text field
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        switch textField {
        case nameTextField:
            passTextField.becomeFirstResponder()
        case passTextField:
            if !isAuthenticated { // If no authentication exists, continue to signup
                confirmTextField.becomeFirstResponder()
            }
        case confirmTextField:
            urlTextField.becomeFirstResponder()
        case urlTextField:
            print("Signup completed")
        default:
            print("something has gone wrong")
        }
        return true
    }
    
    /**
     * Function for what happens when text field entry has completed
     */
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
        case nameTextField:
            givenUser = textField.text
        case passTextField:
            if isAuthenticated {
                authenticate(textField.text!);
            } else {
                givenPass = textField.text
            }
        case confirmTextField:
            givenConfirm = confirmTextField.text
        case urlTextField:
            givenURL = urlTextField.text
            completeSignup()
        default:
            print("something has gone horribly wrong")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func loginAction(sender: UIButton) {
        // if either text field is empty, warn user with alert
        if (nameTextField.text == "" || passTextField.text == "") {
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong username or password." as String, preferredStyle:.Alert)
            let okAction = UIAlertAction(title: "I got this", style: .Default, handler: nil)
            alertView.addAction(okAction)
            self.presentViewController(alertView, animated: true, completion: nil)
            return;
        }
        
        // Remove keyboards from text fields
        //nameTextField.resignFirstResponder()
        //passTextField.resignFirstResponder()
        
        // 3.
        /*if sender.tag == createLoginButtonTag {
            
            // 4.
            let hasLoginKey = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
            if hasLoginKey == false {
                NSUserDefaults.standardUserDefaults().setValue(self.nameTextField.text, forKey: "username")
            }
            
            // 5.
            MyKeychainWrapper.mySetObject(passTextField.text, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            loginButton.tag = loginButtonTag
            
            performSegueWithIdentifier("dismissLogin", sender: self)
        } else if sender.tag == loginButtonTag {
            // 6.
            if checkLogin(nameTextField.text!, password: passTextField.text!) {
                performSegueWithIdentifier("dismissLogin", sender: self)
            } else {
                // 7.
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password." as String, preferredStyle:.Alert)
                let okAction = UIAlertAction(title: "Foiled Again!", style: .Default, handler: nil)
                alertView.addAction(okAction)
                self.presentViewController(alertView, animated: true, completion: nil)
            }
        }*/
    }
    
    // MARK: Navigation
    

    // MARK: Helper functions
    func checkLogin(username: String, password: String ) -> Bool {
        // Compare entered username and passwords to keychain user and pass
        if password == MyKeychainWrapper.myObjectForKey("v_Data") as? String &&
            username == NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
            return true
        } else {
            return false
        }
    }
    
    func authenticate(password: String){
        let username: String = nameTextField.text!
        
        if ( username.isEmpty || password.isEmpty ) {
            
            
        } else {
            
            
        }
        
    }
    
    func completeSignup(){
        
    }
}


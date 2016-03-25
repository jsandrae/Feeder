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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createInfoLabel: UILabel!
    
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    var login: Login?
    var givenUser: String?
    var givenPass: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 1.
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        
        // 2.
        if hasLogin {
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            loginButton.tag = loginButtonTag
            createInfoLabel.hidden = true
        } else {
            loginButton.setTitle("Create", forState: UIControlState.Normal)
            loginButton.tag = createLoginButtonTag
            createInfoLabel.hidden = false
        }
        
        // 3.
        if let storedUsername = NSUserDefaults.standardUserDefaults().valueForKey("username") as? String {
            nameTextField.text = storedUsername as String
        }
        
        // Set up view controller to be own text field delegates
        nameTextField.delegate = self
        passTextField.delegate = self
        
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        switch textField {
        case nameTextField:
            passTextField.becomeFirstResponder()
        default:
            print("something has gone wrong")
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
            case nameTextField:
                givenUser = textField.text
            case passTextField:
                givenPass = textField.text
                authenticate();
            default:
                print("something has gone horribly wrong")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    func authenticate(){
        let username: String = nameTextField.text!
        let password: String = passTextField.text!
        
        if ( username.isEmpty || password.isEmpty ) {
            
            
        } else {
        
            
        }
        
        
    }

    // MARK: NSCoding
    func loadLogin() -> Login? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Login.ArchiveURL.path!) as? Login
    }
}


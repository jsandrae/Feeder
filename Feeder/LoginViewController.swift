//
//  LoginViewController.swift
//  Feeder
//
//  Created by Jason Andrae on 3/13/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var login: Login?
    var username: String?
    var password: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
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
        case passTextField:
            print(password)
        default:
            print("something has gone wrong")
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField {
            case nameTextField:
                username = textField.text
            case passTextField:
                password = textField.text
            default:
                print("something has gone horribly wrong")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  CreateAccountVC.swift
//  Feeder
//
//  Created by Jason Andrae on 3/21/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
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
        if textField == nameTextField {
            passTextField.becomeFirstResponder()
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
    
    // MARK: Actions
    
    @IBAction func gotoLogin(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

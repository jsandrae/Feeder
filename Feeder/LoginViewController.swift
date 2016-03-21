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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set up view controller to be own text field delegate
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


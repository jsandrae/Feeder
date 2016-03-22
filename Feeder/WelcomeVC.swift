//
//  WelcomeVC.swift
//  Feeder
//
//  Created by Jason Andrae on 3/21/16.
//  Copyright © 2016 Jason Andrae. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    // MARK: Properties
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("gotoLogin", sender: self)
    }
    
    // MARK: Actions
    // Logout button action
    @IBAction func logoutTapped(sender: UIButton) {
        self.performSegueWithIdentifier("gotoLogin", sender: self)
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

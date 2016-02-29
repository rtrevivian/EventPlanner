//
//  LoginAttendeeViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    lazy var eventPlanner: EventPlanner = {
       return EventPlanner.sharedInstance()
    }()
    
    let segueEvents = "segueEvents"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = "rich"
        passwordTextField.text = "Password1"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        navigationController?.toolbarHidden = true
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueEvents {
            
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapLoginButton(sender: UIButton) {
        loginButton.enabled = false
        eventPlanner.login("rich", password: "Password1") { (success, result) -> Void in
            if success {
                self.performSegueWithIdentifier(self.segueEvents, sender: self)
                self.loginButton.enabled = true
            } else {
                if let message = result as? String {
                    self.presentSimpleAlert(nil, message: message)
                }
                self.loginButton.enabled = true
            }
        }
    }

}

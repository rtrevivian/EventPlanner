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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var eventPlanner: EventPlanner = {
       return EventPlanner.sharedInstance()
    }()
    
    let segueEvents = "segueEvents"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.backgroundColor = Colors.color1
        loginButton.tintColor = UIColor.whiteColor()
        emailTextField.text = "rich"
        passwordTextField.text = "Password1"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        navigationController?.toolbarHidden = true
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }

    // MARK: - Actions
    
    @IBAction func didTapLoginButton(sender: UIButton) {
        login(emailTextField.text!, password: passwordTextField.text!)
    }
    
    func login(username: String, password: String) {
        if let username = emailTextField.text {
            if username.isEmpty {
                presentSimpleAlert("Email required", message: "Please enter a valid email")
            } else {
                if let password = passwordTextField.text {
                    if password.isEmpty {
                        presentSimpleAlert("Password required", message: "Please enter a password")
                    } else {
                        loginButton.enabled = false
                        activityIndicator.startAnimating()
                        eventPlanner.login(username, password: password) { (success, result) -> Void in
                            if success {
                                self.eventPlanner.getEvents({ (success) -> Void in
                                    self.performSegueWithIdentifier(self.segueEvents, sender: self)
                                    self.loginButton.enabled = true
                                })
                            } else {
                                if let message = result as? String {
                                    self.presentSimpleAlert(nil, message: message)
                                }
                            }
                            self.loginButton.enabled = true
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }

}

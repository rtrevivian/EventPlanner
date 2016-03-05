//
//  LoginAttendeeViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    lazy var eventPlanner: EventPlanner = {
       return EventPlanner.sharedInstance()
    }()
    
    let segueEvents = "segueEvents"
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginStack.alpha = 0
        eventPlanner.start { (success) -> Void in
            self.loginStack.alpha = 1
            if success {
                self.eventPlanner.fetchUsers({ () -> Void in
                    if let user = self.eventPlanner.user {
                        self.emailTextField.text = user.username
                        self.passwordTextField.text = user.password
                        self.login()
                    }
                })
            } else {
                self.presentSimpleAlert("Server unavailable", message: "Please try again later")
            }
        }
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.backgroundColor = Colors.purple
        loginButton.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        navigationController?.toolbarHidden = true
        KeyboardController.addObservers(self)
        clearTextFields()
        setEnabled(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        KeyboardController.removeObservers(self)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= KeyboardController.getKeyboardHeight(notification) / 2
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    // MARK: - Text field delegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            login()
            if textField.isFirstResponder() {
                textField.resignFirstResponder()
            }
        }
        return true
    }
    
    // MARK: - Helpers
    
    func login() {
        if let username = emailTextField.text {
            if username.isEmpty {
                presentSimpleAlert("Email required", message: "Please enter a valid email")
            } else {
                if let password = passwordTextField.text {
                    if password.isEmpty {
                        presentSimpleAlert("Password required", message: "Please enter a password")
                    } else {
                        setEnabled(false)
                        eventPlanner.login(username, password: password) { (success, result) -> Void in
                            if success {
                                self.eventPlanner.getEvents({ (success) -> Void in
                                    self.performSegueWithIdentifier(self.segueEvents, sender: self)
                                })
                            } else {
                                self.presentSimpleAlert("Login error", message: "Please try again")
                                self.setEnabled(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func setEnabled(enabled: Bool) {
        emailTextField.enabled = enabled
        passwordTextField.enabled = enabled
        loginButton.enabled = enabled
        enabled ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    // MARK: - Actions
    
    @IBAction func didTapLoginButton(sender: UIButton) {
        login()
    }

}

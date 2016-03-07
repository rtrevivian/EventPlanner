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
    
    // MARK: - Properties

    @IBOutlet weak var loginStack: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    lazy var eventPlanner: EventPlanner = {
       return EventPlanner.sharedInstance()
    }()
    
    let segueEvents = "segueEvents"
    let segueSignUp = "segueSignUp"
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginStack.alpha = 0
        eventPlanner.start { (success) -> Void in
            self.loginStack.alpha = 1
            if success {
                self.eventPlanner.fetchUsers({ () -> Void in
                    if let user = self.eventPlanner.user {
                        self.usernameTextField.text = user.username
                        self.passwordTextField.text = user.password
                        self.login()
                    }
                })
            } else {
                self.presentSimpleAlert("Server unavailable", message: "Please try again later")
            }
        }
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        submitButton.tintColor = UIColor.whiteColor()
        signUpButton.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        navigationController?.toolbarHidden = true
        KeyboardController.addObservers(self)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
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
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            if textField.isFirstResponder() {
                textField.resignFirstResponder()
            }
            login()
        }
        return true
    }
    
    // MARK: - Helpers
    
    func login() {
        if let username = usernameTextField.text {
            if username.isEmpty {
                presentSimpleAlert("Username required", message: "Please enter a username")
            } else {
                if let password = passwordTextField.text {
                    if password.isEmpty {
                        presentSimpleAlert("Password required", message: "Please enter a password")
                    } else {
                        setEnabled(false)
                        eventPlanner.login(username, password: password) { (error) -> Void in
                            guard error == nil else {
                                self.presentSimpleAlert("Login Error", message: "Please try again")
                                self.setEnabled(true)
                                return
                            }
                            self.eventPlanner.getEvents({ (success) -> Void in
                                self.performSegueWithIdentifier(self.segueEvents, sender: self)
                            })
                        }
                    }
                }
            }
        }
    }
    
    func setEnabled(enabled: Bool) {
        usernameTextField.enabled = enabled
        passwordTextField.enabled = enabled
        submitButton.enabled = enabled
        enabled ? activityIndicator.stopAnimating() : activityIndicator.startAnimating()
    }

    // MARK: - Actions
    
    @IBAction func didTapSubmitButton(sender: UIButton) {
        login()
    }

    @IBAction func didTapSignUpButton(sender: UIButton) {
        performSegueWithIdentifier(segueSignUp, sender: self)
    }
    
}

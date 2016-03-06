//
//  SignupViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/6/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.tintColor = UIColor.whiteColor()
        backButton.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = true
        navigationController?.toolbarHidden = true
        KeyboardController.addObservers(self)
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
            signUp()
        }
        return true
    }
    
    // MARK: - Helpers
    
    func signUp() {
        if let username = usernameTextField.text {
            if username.isEmpty {
                presentSimpleAlert("Username required", message: "Please enter a username")
            } else {
                if let password = passwordTextField.text {
                    if password.isEmpty {
                        presentSimpleAlert("Password required", message: "Please enter a password")
                    } else {
                        setEnabled(false)
                        eventPlanner.signUp(usernameTextField.text!, password: passwordTextField.text!) { (error) -> Void in
                            guard error == nil else {
                                self.setEnabled(true)
                                self.presentSimpleAlert("Sign up error", message: error?.localizedDescription)
                                return
                            }
                            let alert = AlertViewController(title: "User created", message: "Welcome to Event Planner", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                                self.navigationController?.popViewControllerAnimated(true)
                            }))
                            self.presentViewController(alert, animated: true, completion: nil)
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
        signUp()
    }
    
    @IBAction func didTapBackButton(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }

}

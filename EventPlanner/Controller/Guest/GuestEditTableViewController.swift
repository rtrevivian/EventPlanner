//
//  GuestEditTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/29/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class GuestEditTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Outlet textfield
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    
    // MARK: - Outlet cells
    
    @IBOutlet weak var twitterCell: UITableViewCell!
    @IBOutlet weak var facebookCell: UITableViewCell!
    @IBOutlet weak var instagramCell: UITableViewCell!
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()

    var editGuest: Guest!
    var guest: Guest!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFields: [UITextField] = [
            nameTextField,
            addressTextField,
            phoneTextField,
            emailTextField,
            websiteTextField,
            twitterTextField,
            facebookTextField,
            instagramTextField
        ]
        for textField in textFields {
            textField.delegate = self
        }
        
        title = "New Guest"
        guest = Guest()
        if editGuest != nil {
            guest.clone(editGuest)
            title = editGuest.name
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTextField.text = guest.name
        addressTextField.text = guest.address
        phoneTextField.text = guest.phone
        emailTextField.text = guest.email
        websiteTextField.text = guest.website
        twitterTextField.text = guest.twitter
        facebookTextField.text = guest.facebook
        nameTextField.text = guest.instagram
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: - Text field delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let oldValue = textField.text {
            let newValue = (oldValue as NSString).stringByReplacingCharactersInRange(range, withString: string)
            switch textField {
            case nameTextField:
                guest.name = newValue
                break;
            case facebookTextField:
                guest.facebook = newValue
                break;
            case instagramTextField:
                guest.instagram = newValue
                break;
            case twitterTextField:
                guest.twitter = newValue
                break;
            case addressTextField:
                guest.address = newValue
                break;
            case emailTextField:
                guest.email = newValue
                break;
            case phoneTextField:
                guest.phone = newValue
                break;
            case websiteTextField:
                guest.website = newValue
                break;
            default:
                break;
            }
        }
        return true
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            guest.name = ""
            break;
        case facebookTextField:
            guest.facebook = ""
            break;
        case instagramTextField:
            guest.instagram = ""
            break;
        case twitterTextField:
            guest.twitter = ""
            break;
        case addressTextField:
            guest.address = ""
            break;
        case emailTextField:
            guest.email = ""
            break;
        case phoneTextField:
            guest.phone = ""
            break;
        case websiteTextField:
            guest.website = ""
            break;
        default:
            break;
        }
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Actions
    
    func didTapCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapSaveButton(sender: UIBarButtonSystemItem) {
        if editGuest != nil {
            editGuest.clone(guest)
            guest = editGuest
        }
        eventPlanner.saveGuests([guest]) { (success) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}

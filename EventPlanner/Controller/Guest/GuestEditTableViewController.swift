//
//  GuestEditTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/29/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class GuestEditTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Outlet textfields
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var rsvpTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    @IBOutlet weak var twitterTextField: UITextField!
    @IBOutlet weak var facebookTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    
    // MARK: - Outlet cells
    
    @IBOutlet weak var rsvpCell: UITableViewCell!

    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()

    let segueGuestSelect = "segueGuestSelect"
    
    var event: Event!
    var editGuest: Guest!
    var guest: Guest!
    var textFields: [UITextField]!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields = [
            nameTextField,
            emailTextField,
            
            addressTextField,
            phoneTextField,
            websiteTextField,
            
            twitterTextField,
            facebookTextField,
            instagramTextField
        ]
        for textField in textFields {
            textField.delegate = self
        }
        
        navigationItem.rightBarButtonItem?.enabled = false
        
        guest = Guest()
        if editGuest != nil {
            guest.clone(editGuest)
            title = guest.name
        } else {
            guest.event = event
            title = "New Guest"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationGuestChanged", name: Guest.Change.GuestChanged.rawValue, object: nil)
        notificationGuestChanged()
        
        nameTextField.text = guest.name
        rsvpTextField.text = guest.rsvpType?.name
        
        addressTextField.text = guest.address
        emailTextField.text = guest.email
        phoneTextField.text = guest.phone
        websiteTextField.text = guest.website
        
        twitterTextField.text = guest.twitter
        facebookTextField.text = guest.facebook
        instagramTextField.text = guest.instagram
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        hideKeyboard()
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return tableView.cellForRowAtIndexPath(indexPath) == rsvpCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell == rsvpCell {
            performSegueWithIdentifier(segueGuestSelect, sender: self)
        }
    }
    
    // MARK: - Text field delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let oldValue = textField.text {
            let newValue = (oldValue as NSString).stringByReplacingCharactersInRange(range, withString: string)
            switch textField {
            case nameTextField:
                guest.name = newValue
                break;
            case emailTextField:
                guest.email = newValue
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
    
    // MARK: - Helpers
    
    func hideKeyboard() {
        for textField in textFields {
            if textField.isFirstResponder() {
                textField.resignFirstResponder()
            }
        }
    }
    
    // MARK: - Actions
    
    func didTapCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapSaveButton(sender: UIBarButtonItem) {
        sender.enabled = false
        eventPlanner.saveGuests([guest]) { (error, guests) -> Void in
            guard error == nil else {
                self.presentSimpleAlert("Unable to save guest", message: error?.localizedDescription)
                sender.enabled = true
                return
            }
            if self.editGuest != nil {
                self.editGuest.clone(guests![0])
            } else {
                self.event.guests.appendContentsOf(guests!)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func notificationGuestChanged() {
        navigationItem.rightBarButtonItem?.enabled = !guest.name.isEmpty
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? GuestSelectTableViewController {
            controller.guest = guest
        }
    }
    
}

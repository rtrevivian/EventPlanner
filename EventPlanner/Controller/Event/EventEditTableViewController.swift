//
//  EventEditTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/24/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class EventEditTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Outlet textfields
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var dressCodeTextField: UITextField!
    
    @IBOutlet weak var startTextField: UITextField!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var rsvpTextField: UITextField!
    
    @IBOutlet weak var venueAddressTextField: UITextField!
    @IBOutlet weak var venuePhoneTextField: UITextField!
    @IBOutlet weak var venueEmailTextField: UITextField!
    @IBOutlet weak var venueWebsiteTextField: UITextField!
    
    @IBOutlet weak var socialTwitterTextField: UITextField!
    @IBOutlet weak var socialFacebookTextField: UITextField!
    @IBOutlet weak var socialInstagramTextField: UITextField!
    
    // MARK: - Outlet cells
    
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var dressCodeCell: UITableViewCell!
    
    @IBOutlet weak var startCell: UITableViewCell!
    @IBOutlet weak var endCell: UITableViewCell!
    @IBOutlet weak var rsvpCell: UITableViewCell!
    
    @IBOutlet weak var socialTwitterCell: UITableViewCell!
    @IBOutlet weak var socialFacebookCell: UITableViewCell!
    @IBOutlet weak var socialInstagramCell: UITableViewCell!
    
    // MARK: - Outlet labels
    
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var rsvpLabel: UILabel!
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    var editEvent: Event!
    var event: Event!
    
    let segueSelect = "segueSelect"
    let segueDate = "segueDate"
    
    var endCellEnabled = false {
        didSet {
            endLabel.alpha = endCellEnabled ? 1 : 0.5
            rsvpLabel.alpha = endCellEnabled ? 1 : 0.5
        }
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       let textFields: [UITextField] = [
            nameTextField,
            venueAddressTextField,
            venuePhoneTextField,
            venueEmailTextField,
            venueWebsiteTextField,
            socialTwitterTextField,
            socialFacebookTextField,
            socialInstagramTextField
        ]
        for textField in textFields {
            textField.delegate = self
        }
        
        navigationItem.rightBarButtonItem?.enabled = false
        
        event = Event()
        if editEvent != nil {
            event.clone(editEvent)
            title = event.name
        } else {
            event.user = KCSUser.activeUser()
            title = "New Event"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationEventChanged", name: Event.Change.EventChanged.rawValue, object: nil)
        notificationEventChanged()
        
        endCellEnabled = event.startDate != nil
        
        nameTextField.text = event.name
        venueAddressTextField.text = event.address
        venuePhoneTextField.text = event.phone
        venueEmailTextField.text = event.email
        venueWebsiteTextField.text = event.website
        socialTwitterTextField.text = event.twitter
        socialFacebookTextField.text = event.facebook
        socialInstagramTextField.text = event.instagram
        
        typeTextField.text = event.eventType == nil ? nil : event.eventType?.name
        dressCodeTextField.text = event.dressCode == nil ? nil : event.dressCode?.name
        
        startTextField.text = event.start
        endTextField.text = event.end
        rsvpTextField.text = event.rsvp
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Table view delegate
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var title: String?
        var message: String?
        switch cell! {
        case socialFacebookCell:
            title = "Facebook setup"
            message = "Add a Facebook page URL"
            break;
        case socialTwitterCell:
            title = "Twitter setup"
            message = "Add a hashtag for guests"
            break;
        case socialInstagramCell:
            title = "Instagram setup"
            message = "Add a hashtag for guests"
            break;
        default:
            break;
        }
        if let _ = title {
            presentSimpleAlert(title, message: message)
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var enable = true
        if cell == endCell || cell == rsvpCell {
            enable = endCellEnabled
        }
        return enable
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch cell! {
        case typeCell:
            performSegueWithIdentifier(segueSelect, sender: typeCell)
            break;
        case dressCodeCell:
            performSegueWithIdentifier(segueSelect, sender: dressCodeCell)
            break;
        case startCell:
            performSegueWithIdentifier(segueDate, sender: startCell)
            break;
        case endCell:
            performSegueWithIdentifier(segueDate, sender: endCell)
            break;
        case rsvpCell:
            performSegueWithIdentifier(segueDate, sender: rsvpCell)
            break;
        default:
            break;
        }
    }
    
    // MARK: - Text field delegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if let oldValue = textField.text {
            let newValue = (oldValue as NSString).stringByReplacingCharactersInRange(range, withString: string)
            switch textField {
            case nameTextField:
                event.name = newValue
                break;
            case socialFacebookTextField:
                event.facebook = newValue
                break;
            case socialInstagramTextField:
                event.instagram = newValue
                break;
            case socialTwitterTextField:
                event.twitter = newValue
                break;
            case venueAddressTextField:
                event.address = newValue
                break;
            case venueEmailTextField:
                event.email = newValue
                break;
            case venuePhoneTextField:
                event.phone = newValue
                break;
            case venueWebsiteTextField:
                event.website = newValue
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
            event.name = ""
            break;
        case socialFacebookTextField:
            event.facebook = ""
            break;
        case socialInstagramTextField:
            event.instagram = ""
            break;
        case socialTwitterTextField:
            event.twitter = ""
            break;
        case venueAddressTextField:
            event.address = ""
            break;
        case venueEmailTextField:
            event.email = ""
            break;
        case venuePhoneTextField:
            event.phone = ""
            break;
        case venueWebsiteTextField:
            event.website = ""
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
    
    func didTapSaveButton(sender: UIBarButtonItem) {
        sender.enabled = false
        if editEvent != nil {
            editEvent.clone(event)
            event = editEvent
        }
        eventPlanner.saveEvents([event]) { (success) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func notificationEventChanged() {
        navigationItem.rightBarButtonItem?.enabled = !event.name.isEmpty
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueSelect {
            if let controller = segue.destinationViewController as? EventSelectTableViewController {
                if let cell = sender as? UITableViewCell {
                    controller.mode = cell == dressCodeCell ? .DressCode : .Type
                    controller.event = event
                }
            }
        } else if segue.identifier == segueDate {
            if let controller = segue.destinationViewController as? EventDatePickerTableViewController {
                controller.event = event
                if let cell = sender as? UITableViewCell {
                    switch cell {
                    case startCell:
                        controller.key = EventDatePickerTableViewController.Keys.start
                        break;
                    case endCell:
                        controller.key = EventDatePickerTableViewController.Keys.end
                        break;
                    case rsvpCell:
                        controller.key = EventDatePickerTableViewController.Keys.rsvp
                        break;
                    default:
                        break;
                    }
                }
            }
        }
    }

}

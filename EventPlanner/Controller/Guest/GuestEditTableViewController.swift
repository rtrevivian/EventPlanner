//
//  GuestEditTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/29/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class GuestEditTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()

    var editPerson: Guest!
    var person: Guest!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        person = Guest()
        if editPerson != nil {
            person.clone(editPerson)
            title = editPerson.name
        }
    }
    
    // MARK: - Actions
    
    func didTapCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapSaveButton(sender: UIBarButtonSystemItem) {
        if editPerson != nil {
            editPerson.clone(person)
            person = editPerson
        }
        eventPlanner.saveGuests([person]) { (success) -> Void in   
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}

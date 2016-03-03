//
//  TableEditTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/2/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class TableEditTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var seatsTextField: UITextField!
    @IBOutlet weak var seatsStepper: UIStepper!
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    var event: Event!
    var editTable: Table!
    var table: Table!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem?.enabled = false
        nameTextField.delegate = self
        
        table = Table()
        if editTable != nil {
            table.clone(editTable)
            title = table.name
        } else {
            table.event = event
            title = "New Table"
        }
        
        seatsStepper.addTarget(self, action: "didChangeSeatsStepper:", forControlEvents: .ValueChanged)
        seatsStepper.hidden = editTable != nil
        seatsStepper.value = Double(table.seats)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationTableChanged", name: Table.Change.TableChanged.rawValue, object: nil)
        reload()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
                table.name = newValue
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
            table.name = ""
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
    
    func reload() {
        nameTextField.text = table.name
        seatsTextField.text = table.seats.description
    }
    
    func notificationTableChanged() {
        navigationItem.rightBarButtonItem?.enabled = !table.name.isEmpty
    }
    
    // MARK: - Actions
    
    func didChangeSeatsStepper(sender: UIStepper) {
        table.seats = Int(sender.value)
        reload()
    }
    
    func didTapCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func didTapSaveButton(sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem?.enabled = false
        if editTable != nil {
            editTable.clone(table)
            table = editTable
        }
        eventPlanner.saveTables([table]) { (tables) -> Void in
            self.table.event.tables.appendContentsOf(tables)
            if self.editTable == nil {
                var newSeats = [Seat]()
                for i in 1...self.table.seats {
                    let seat = Seat()
                    seat.number = i
                    seat.table = self.table
                    newSeats.append(seat)
                }
                self.eventPlanner.saveSeats(newSeats, completionHandler: { (seats) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

}

//
//  DatePickerTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/23/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class EventDatePickerTableViewController: UITableViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var dateCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - Properties
    
    struct Keys {
        static let start = "Start"
        static let end = "End"
        static let rsvp = "RSVP"
    }
    
    var enabled = false {
        didSet {
            enabledSwitch.on = enabled
            dateCell.hidden = !enabled
            setDate(enabled ? datePicker.date : nil)
        }
    }
    
    var event: Event!
    var key: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enabledSwitch.addTarget(self, action: "didChangeEnabledSwitch:", forControlEvents: .ValueChanged)
        datePicker.addTarget(self, action: "didChangeDatePicker:", forControlEvents: .ValueChanged)
        
        if let _ = key {
            label.text = key
            switch key {
            case Keys.end:
                sePickerDate(event.endDate, minimumDate: event.startDate?.dateByAddingTimeInterval(NSTimeInterval(60 * 60)), maximumDate: nil)
                break;
            case Keys.rsvp:
                sePickerDate(event.rsvpDate, minimumDate: nil, maximumDate: event.startDate?.dateByAddingTimeInterval(NSTimeInterval(-60)))
                break;
            case Keys.start:
                sePickerDate(event.startDate, minimumDate: NSDate(), maximumDate: nil)
                break;
            default:
                break;
            }
            
        }
    }
    
    // MARK: - Actions
    
    func didChangeEnabledSwitch(sender: UISwitch) {
        enabled = sender.on
    }
    
    func didChangeDatePicker(sender: UIDatePicker) {
        setDate(sender.date)
    }
    
    // MARK: - Helpers
    
    func setDate(date: NSDate?) {
        switch key {
        case Keys.end:
            event.endDate = date
            break;
        case Keys.rsvp:
            event.rsvpDate = date
            break;
        case Keys.start:
            event.startDate = date
            break;
        default:
            break;
        }
    }
    
    func sePickerDate(date: NSDate?, minimumDate: NSDate?, maximumDate: NSDate?) {
        if let _ = minimumDate {
            datePicker.minimumDate = minimumDate!
        }
        if let _ = maximumDate {
            datePicker.maximumDate = maximumDate!
        }
        if let _ = date {
            datePicker.date = date!
            enabled = true
        } else {
            enabled = false
        }
    }

}

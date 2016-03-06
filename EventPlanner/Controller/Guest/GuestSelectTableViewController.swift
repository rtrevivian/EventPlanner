//
//  GuestSelectTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/3/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class GuestSelectTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    var guest: Guest!
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventPlanner.rsvpTypes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.accessoryType =  eventPlanner.rsvpTypes[indexPath.row].entityId == guest.rsvpType?.entityId ? .Checkmark : .None
        cell.textLabel?.text = eventPlanner.rsvpTypes[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guest.rsvpType = eventPlanner.rsvpTypes[indexPath.row]
        tableView.reloadData()
        navigationController?.popViewControllerAnimated(true)
    }

}

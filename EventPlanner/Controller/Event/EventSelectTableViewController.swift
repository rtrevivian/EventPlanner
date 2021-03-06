//
//  SelectTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/23/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class EventSelectTableViewController: UITableViewController {
    
    // MARK: - Enums
    
    enum Mode {
        
        case Type, DressCode
    }
    
    // MARK: - Properties

    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    var event: Event!    
    var mode: Mode!

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mode == .Type ? eventPlanner.eventTypes.count : eventPlanner.dressCodes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if mode == .Type {
            cell.accessoryType =  eventPlanner.eventTypes[indexPath.row].entityId == event.eventType?.entityId ? .Checkmark : .None
            cell.textLabel?.text = eventPlanner.eventTypes[indexPath.row].name
        } else {
            cell.accessoryType = eventPlanner.dressCodes[indexPath.row].entityId == event.dressCode?.entityId ? .Checkmark : .None
            cell.textLabel?.text = eventPlanner.dressCodes[indexPath.row].name
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if mode == .Type {
            event.eventType = eventPlanner.eventTypes[indexPath.row]
        } else {
            event.dressCode = eventPlanner.dressCodes[indexPath.row]
        }
        tableView.reloadData()
        navigationController?.popViewControllerAnimated(true)
    }

}

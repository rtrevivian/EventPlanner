//
//  GuestsTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/3/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class GuestsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    let segueGuestDetail = "segueGuestDetail"
    
    var event: Event!
    var swipedIndexPath: NSIndexPath!
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        navigationItem.rightBarButtonItem = self.editButtonItem()
        setToolbarItems([getFlexibleSpace(), UIBarButtonItem(title: "New Guest", style: .Plain, target: self, action: "didTapNewButton:"), getFlexibleSpace()], animated: true)
        
        title = event.name
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.toolbarHidden = false
        reload()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return event.guests.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = event.guests[indexPath.row].name
        return cell
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, willBeginEditingRowAtIndexPath: indexPath)
        swipedIndexPath = indexPath
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didEndEditingRowAtIndexPath: indexPath)
        swipedIndexPath = nil
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            event.deleteGuests([event.guests[indexPath.row]], completionHandler: { () -> Void in
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !editing {
            performSegueWithIdentifier(segueGuestDetail, sender: event.guests[indexPath.row])
        }
    }
    
    // MARK: - Refresh
    
    func refresh() {
        event.update { () -> Void in
            self.reload()
        }
    }
    
    func reload() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.tableView.reloadData()
        }
        if let _ = refreshControl {
            if refreshControl!.refreshing {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Actions
    
    func didTapNewButton(sender: UIBarButtonItem) {
        if let navigator = self.storyboard?.instantiateViewControllerWithIdentifier("guestEditNavigator") as? UINavigationController {
            if let controller = navigator.viewControllers[0] as? GuestEditTableViewController {
                controller.event = self.event
                controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: controller, action: "didTapCancelButton:")
                controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: controller, action: "didTapSaveButton:")
                self.presentViewController(navigator, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let event = sender as? Event {
            if let controller = segue.destinationViewController as? GuestEditTableViewController {
                controller.event = event
            }
        } else if let guest = sender as? Guest {
            if let controller = segue.destinationViewController as? GuestDetailTableViewController {
                guest.event = event
                controller.guest = guest
            }
        }
    }
    
}

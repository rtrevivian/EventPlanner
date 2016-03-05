//
//  EventsTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()

    let segueEventDetail = "segueEventDetail"
    let segueGuests = "segueGuests"
    
    var swipedIndexPath: NSIndexPath!
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
    
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Done, target: self, action: "didTapLogoutButton:")
        navigationItem.rightBarButtonItem = editButtonItem()
        
        setToolbarItems([getFlexibleSpace(), UIBarButtonItem(title: "New Event", style: .Plain, target: self, action: "didTapNewButton:"), getFlexibleSpace()], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = false
        navigationController?.toolbarHidden = false

        reload()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventPlanner.events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let event = eventPlanner.events[indexPath.row]
        cell.textLabel?.text = event.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didEndEditingRowAtIndexPath: indexPath)
        swipedIndexPath = nil
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Delete") { (action, indexPath) -> Void in
            let alert = self.eventPlanner.events[indexPath.row].deleteSelf({ () -> Void in
                self.editing = false
                }, confirm: { () -> Void in
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            self.presentViewController(alert, animated: true, completion: nil)
        }
        let empty = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Empty") { (action, indexPath) -> Void in
            let alert = self.eventPlanner.events[indexPath.row].empty({ () -> Void in
                    self.editing = false
                }, confirm: { () -> Void in
                    self.editing = false
            })
            self.presentViewController(alert, animated: true, completion: nil)
        }
        empty.backgroundColor = Colors.purple
        return [delete, empty]
    }

    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, willBeginEditingRowAtIndexPath: indexPath)
        swipedIndexPath = indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !editing {
            performSegueWithIdentifier(segueGuests, sender: eventPlanner.events[indexPath.row])
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if !editing {
            performSegueWithIdentifier(segueEventDetail, sender: eventPlanner.events[indexPath.row])
        }
    }
    
    // MARK: - Refresh
    
    func refresh() {
        eventPlanner.getEvents { (success) -> Void in
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
        if let navigator = storyboard?.instantiateViewControllerWithIdentifier("eventEditNavigator") as? UINavigationController {
            if let controller = navigator.viewControllers[0] as? EventEditTableViewController {
                controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: controller, action: "didTapCancelButton:")
                controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: controller, action: "didTapSaveButton:")
                presentViewController(navigator, animated: true, completion: nil)
            }
        }
    }
    
    func didTapLogoutButton(sender: UIBarButtonItem) {
        eventPlanner.logout(nil)
        navigationController?.popToRootViewControllerAnimated(true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let event = sender as? Event {
            if let controller = segue.destinationViewController as? GuestsTableViewController {
                controller.event = event
            } else if let controller = segue.destinationViewController as? EventDetailTableViewController {
                controller.event = event
            }
        }
    }

}

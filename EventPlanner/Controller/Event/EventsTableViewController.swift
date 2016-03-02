//
//  EventsTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    lazy var logoutButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Logout", style: .Done, target: self, action: "didTapLogoutButton:")
    }()
    
    lazy var addButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "didTapAddButton:")
    }()
    
    lazy var flexibleSpace: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
    }()
    
    var swipedIndexPath: NSIndexPath!
    
    let segueEventDetail = "segueEventDetail"
    let segueEventTabs = "segueEventTabs"
    
    // MARK: - View

    override func viewDidLoad() {
        super.viewDidLoad()
    
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: "refresh", forControlEvents: .ValueChanged)
        
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = editButtonItem()
        setToolbarItems([flexibleSpace, addButton], animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBarHidden = false
        navigationController?.toolbarHidden = false
        refresh()
    }
    
    // MARK: - Data management
    
    func refresh() {
        eventPlanner.getEvents { (success) -> Void in
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
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
            eventPlanner.deleteEvents([eventPlanner.events[indexPath.row]], completionHandler: { (success) -> Void in
                if success {
                    self.eventPlanner.events.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            })
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !editing {
            performSegueWithIdentifier(segueEventTabs, sender: eventPlanner.events[indexPath.row])
        }
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        if !editing {
            performSegueWithIdentifier(segueEventDetail, sender: eventPlanner.events[indexPath.row])
        }
    }
    
    // MARK: - Actions
    
    func didTapAddButton(sender: UIBarButtonItem) {
        if let navigator = storyboard?.instantiateViewControllerWithIdentifier("eventEditNavigator") as? UINavigationController {
            if let controller = navigator.viewControllers[0] as? EventEditTableViewController {
                controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: controller, action: "didTapCancelButton:")
                controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: controller, action: "didTapSaveButton:")
                presentViewController(navigator, animated: true, completion: nil)
            }
        }
    }
    
    func didTapLogoutButton(sender: UIBarButtonItem) {
        eventPlanner.logout()
        navigationController?.popToRootViewControllerAnimated(true)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let event = sender as? Event {
            if let controller = segue.destinationViewController as? EventTabsTableViewController {
                controller.event = event
            } else if let controller = segue.destinationViewController as? EventDetailTableViewController {
                controller.event = event
            }
        }
    }

}

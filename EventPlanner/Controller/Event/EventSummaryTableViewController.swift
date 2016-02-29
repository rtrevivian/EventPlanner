//
//  EventTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class EventSumTableViewController: UITableViewController {
    
    // MARK: - Outlet cells
    
    @IBOutlet weak var typeCell: UITableViewCell!
    @IBOutlet weak var dressCodeCell: UITableViewCell!
    
    @IBOutlet weak var startCell: UITableViewCell!
    @IBOutlet weak var endCell: UITableViewCell!
    @IBOutlet weak var rsvpCell: UITableViewCell!
    
    @IBOutlet weak var venueAddressCell: UITableViewCell!
    @IBOutlet weak var venuePhoneCell: UITableViewCell!
    @IBOutlet weak var venueEmailCell: UITableViewCell!
    @IBOutlet weak var venueWebsiteCell: UITableViewCell!
    
    @IBOutlet weak var socialTwitterCell: UITableViewCell!
    @IBOutlet weak var socialFacebookCell: UITableViewCell!
    @IBOutlet weak var socialInstagramCell: UITableViewCell!
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
        
    var event: Event!
    
    let segueEventEdit = "segueEventEdit"
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "load", forControlEvents: UIControlEvents.ValueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "didTapEditButton:")
        load()
        update()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var select = true
        switch cell! {
        case socialFacebookCell:
            select = event.facebook != nil
            break;
        case socialInstagramCell:
            select = event.instagram != nil
            break;
        case socialTwitterCell:
            select = event.twitter != nil
            break;
        case venueAddressCell:
            select = event.address != nil
            break;
        case venueEmailCell:
            select = event.email != nil
            break;
        case venuePhoneCell:
            select = event.phone != nil
            break;
        case venueWebsiteCell:
            select = event.website != nil
            break;
        default:
            break;
        }
        return select
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch cell! {
        case socialFacebookCell:
            openFacebookPage(event.facebook!)
            break;
        case socialInstagramCell:
            openInstagramWithHastag(event.instagram!)
            break;
        case socialTwitterCell:
            openTwitterWithHashtag(event.twitter!)
            break;
        case venueAddressCell:
            openMaps(event.address!)
            break;
        case venueEmailCell:
            openEmail(event.email!)
            break;
        case venuePhoneCell:
            openPhone(event.phone!)
            break;
        case venueWebsiteCell:
            openURL(event.website!)
            break;
        default:
            break;
        }
    }
    
    // MARK: - Actions
    
    func load() {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
//        eventPlanner.getEvent(event) { (success) -> Void in
//            
//        }
    }
    
    func didTapEditButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier(segueEventEdit, sender: self)
    }
    
    func update() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.title = self.event.name
            print(self.event.eventType)
            if let _ = self.event.eventType {
                self.typeCell.detailTextLabel?.text = self.event.eventType?.name
            }
            if let _ = self.event.dressCode {
                self.dressCodeCell.detailTextLabel?.text = self.event.dressCode?.name
            }
            if let _ = self.event.startDate {
                self.startCell.detailTextLabel?.text = self.event.startDate?.description
            }
            if let _ = self.event.endDate {
                self.endCell.detailTextLabel?.text = self.event.endDate?.description
            }
            if let _ = self.event.rsvpDate {
                self.rsvpCell.detailTextLabel?.text = self.event.rsvpDate?.description
            }
            self.venueAddressCell.textLabel?.text = self.event.address
            self.venuePhoneCell.textLabel?.text = self.event.phone
            self.venueEmailCell.textLabel?.text = self.event.email
            self.venueWebsiteCell.textLabel?.text = self.event.website
            
            self.socialTwitterCell.textLabel?.text = self.event.twitter
            self.socialFacebookCell.textLabel?.text = self.event.facebook
            self.socialInstagramCell.textLabel?.text = self.event.instagram
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueEventEdit {
            if let navigator = segue.destinationViewController as? UINavigationController {
                if let controller = navigator.viewControllers[0] as? EventEditTableViewController {
                    controller.editEvent = event
                    controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: controller, action: "didTapCancelButton:")
                    controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: controller, action: "didTapSaveButton:")
                }
            }
        }
    }

}

//
//  EventDetailTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/28/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class EventDetailTableViewController: UITableViewController {
    
    // MARK: - Enums
    
    enum Row: String {
        case BasicDressCode = "Dress code"
        case BasicGuests = "Guests"
        case BasicRSVPs = "RSVPs"
        case BasicType = "Type"
        
        // When
        case WhenStart = "Start"
        case WhenEnd = "End"
        case WhenRSVP = "RSVP"
        
        // Venue
        case VenueAddress = "Address"
        case VenuePhone = "Phone"
        case VenueEmail = "Email"
        case VenueWebsite = "Website"
        
        // Social
        case SocialTwitter = "Twitter"
        case SocialFacebook = "Facebook"
        case SocialInstagram = "Instagram"
        
        // Actions
        case ActionEmpty = "Empty"
        case ActionDelete = "Delete"
    }
    
    // MARK: - Structs
    
    struct Section {
        var header: String?
        var footer: String?
        var rows = [Row]()
        
        init(header: String?, footer: String?) {
            self.header = header
            self.footer = footer
        }
    }
    
    // MARK: - Properties
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    let segueEventEdit = "segueEventEdit"
    
    var event: Event!
    var sections = [Section]()
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "didTapEditButton:")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
        reload()
    }
    
    // MARK: - Data management
    
    func refresh() {
        eventPlanner.getEvent(event) { (error, event) -> Void in
            self.reload()
            guard event == nil else {
                self.presentSimpleAlert("Unable to load event", message: error?.localizedDescription)
                return
            }
            self.event = event
        }
    }
    
    func reload() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.title = self.event.name
            self.sections = [Section]()
            
            var basicRows = [Row]()
            if let _ = self.event.eventType {
                basicRows.append(.BasicType)
            }
            if let _ = self.event.dressCode {
                basicRows.append(.BasicDressCode)
            }
            if !basicRows.isEmpty {
                var basic = Section(header: nil, footer: nil)
                basic.rows = basicRows
                self.sections.append(basic)
            }
            
            var whenRows = [Row]()
            if let _ = self.event.startDate {
                whenRows.append(.WhenStart)
            }
            if let _ = self.event.endDate {
                whenRows.append(.WhenEnd)
            }
            if let _ = self.event.rsvpDate {
                whenRows.append(.WhenRSVP)
            }
            if !whenRows.isEmpty {
                var when = Section(header: "When", footer: nil)
                when.rows = whenRows
                self.sections.append(when)
            }
            
            var venueRows = [Row]()
            if !self.event.address.isEmpty {
                venueRows.append(.VenueAddress)
            }
            if !self.event.phone.isEmpty {
                venueRows.append(.VenuePhone)
            }
            if !self.event.email.isEmpty {
                venueRows.append(.VenueEmail)
            }
            if !self.event.website.isEmpty {
                venueRows.append(.VenueWebsite)
            }
            if !venueRows.isEmpty {
                var venue = Section(header: "Venue", footer: nil)
                venue.rows = venueRows
                self.sections.append(venue)
            }
            
            var socialRows = [Row]()
            if !self.event.twitter.isEmpty {
                socialRows.append(.SocialTwitter)
            }
            if !self.event.facebook.isEmpty {
                socialRows.append(.SocialFacebook)
            }
            if !self.event.instagram.isEmpty {
                socialRows.append(.SocialInstagram)
            }
            if !socialRows.isEmpty {
                var social = Section(header: "Social", footer: nil)
                social.rows = socialRows
                self.sections.append(social)
            }
            
            var actionRows = [Row]()
            actionRows.append(.ActionEmpty)
            actionRows.append(.ActionDelete)
            var actions = Section(header: nil, footer: nil)
            actions.rows = actionRows
            self.sections.append(actions)
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rows.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = getTableViewRow(indexPath)
        var returnCell: UITableViewCell
        if row == .ActionDelete || row == .ActionEmpty {
            let cell = tableView.dequeueReusableCellWithIdentifier("labelCell", forIndexPath: indexPath) as! LabelTableViewCell
            cell.label.textColor = row == .ActionDelete ? UIColor.redColor() : Colors.purple
            cell.label.text = row == .ActionDelete ? "Delete Event" : "Remove Guests"
            returnCell = cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            returnCell = cell
            switch row {
            case .BasicDressCode:
                cell.textLabel?.text = row.rawValue
                cell.detailTextLabel?.text = event.dressCode?.name
                break;
            case .BasicGuests:
                cell.textLabel?.text = row.rawValue
                cell.detailTextLabel?.text = event.guests.count.description
                break;
            case .BasicType:
                cell.textLabel?.text = row.rawValue
                cell.detailTextLabel?.text = event.eventType?.name
                break;
            case .BasicRSVPs:
                cell.textLabel?.text = row.rawValue
                cell.detailTextLabel?.text = event.rsvps.count.description
                break;
            case .SocialFacebook:
                cell.imageView?.image = UIImage(named: "facebook")
                cell.textLabel?.text = event.facebook
                break;
            case .SocialInstagram:
                cell.imageView?.image = UIImage(named: "instagram")
                cell.textLabel?.text = event.instagram
                break;
            case .SocialTwitter:
                cell.imageView?.image = UIImage(named: "twitter")
                cell.textLabel?.text = event.twitter
                break;
            case .VenueAddress:
                cell.imageView?.image = UIImage(named: "location")
                cell.textLabel?.text = event.address
                break;
            case .VenueEmail:
                cell.imageView?.image = UIImage(named: "message")
                cell.textLabel?.text = event.email
                break;
            case .VenuePhone:
                cell.imageView?.image = UIImage(named: "phone")
                cell.textLabel?.text = event.phone
                break;
            case .VenueWebsite:
                cell.imageView?.image = UIImage(named: "link")
                cell.textLabel?.text = event.website
                break;
            case .WhenEnd:
                cell.textLabel?.text = row.rawValue
                cell.detailTextLabel?.text = event.end
                break;
            case .WhenRSVP:
                cell.textLabel?.text = row.rawValue
                cell.detailTextLabel?.text = event.rsvp
                break;
            case .WhenStart:
                cell.textLabel?.text = row.rawValue
                cell.detailTextLabel?.text = event.start
                break;
            default:
                break;
            }
        }
        return returnCell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = getTableViewRow(indexPath)
        switch row {
        case .ActionDelete:
            let alert = event.deleteSelf({ (error) -> Void in
                guard error == nil else {
                    self.presentSimpleAlert("Unable to delete event", message: error?.localizedDescription)
                    return
                }
                }, confirm: { () -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
            })
            self.presentViewController(alert, animated: true, completion: nil)
            break;
        case .ActionEmpty:
            let alert = event.empty(nil, confirm: nil)
            self.presentViewController(alert, animated: true, completion: nil)
            break;
        case .BasicDressCode:
            break;
        case .BasicGuests:
            break;
        case .BasicType:
            break;
        case .BasicRSVPs:
            break;
        case .SocialFacebook:
            openFacebookPage(event.facebook)
            break;
        case .SocialInstagram:
            openInstagramWithHastag(event.instagram)
            break;
        case .SocialTwitter:
            openTwitterWithHashtag(event.twitter)
            break;
        case .VenueAddress:
            openMaps(event.address)
            break;
        case .VenueEmail:
            openEmail(event.email)
            break;
        case .VenuePhone:
            openPhone(event.phone)
            break;
        case .VenueWebsite:
            openURL(event.website)
            break;
        case .WhenEnd:
            break;
        case .WhenRSVP:
            break;
        case .WhenStart:
            break;
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var highlight = false
        let row = getTableViewRow(indexPath)
        switch row {
        case .ActionDelete:
            highlight = true
            break;
        case .ActionEmpty:
            highlight = true
            break;
        case .BasicDressCode:
            break;
        case .BasicGuests:
            break;
        case .BasicType:
            break;
        case .BasicRSVPs:
            break;
        case .SocialFacebook:
            highlight = !event.facebook.isEmpty
            break;
        case .SocialInstagram:
            highlight = !event.instagram.isEmpty
            break;
        case .SocialTwitter:
            highlight = !event.twitter.isEmpty
            break;
        case .VenueAddress:
            highlight = !event.address.isEmpty
            break;
        case .VenueEmail:
            highlight = !event.email.isEmpty
            break;
        case .WhenEnd:
            break;
        case .VenuePhone:
            highlight = !event.phone.isEmpty
            break;
        case .VenueWebsite:
            highlight = !event.website.isEmpty
            break;
        case .WhenRSVP:
            break;
        case .WhenStart:
            break;
        }
        return highlight
    }
    
    func getTableViewRow(indexPath: NSIndexPath) -> Row {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    // MARK: - Actions
    
    func didTapEditButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier(segueEventEdit, sender: self)
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

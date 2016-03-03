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
        case Type
        case DressCode = "Dress code"
        
        // When
        case Start
        case End
        case RSVP
        
        // Venue
        case Address
        case Phone
        case Email
        case Website
        
        // Social
        case Twitter
        case Facebook
        case Instagram
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
        eventPlanner.getEvent(event) { (event) -> Void in
            self.event = event
            self.reload()
        }
    }
    
    func reload() {
        title = event.name
        sections = [Section]()
        
        var basicRows = [Row]()
        if let _ = event.eventType {
            basicRows.append(.Type)
        }
        if let _ = event.dressCode {
            basicRows.append(.DressCode)
        }
        if !basicRows.isEmpty {
            var basic = Section(header: nil, footer: nil)
            basic.rows = basicRows
            sections.append(basic)
        }
        
        var whenRows = [Row]()
        if let _ = event.startDate {
            whenRows.append(.Start)
        }
        if let _ = event.endDate {
            whenRows.append(.End)
        }
        if let _ = event.rsvpDate {
            whenRows.append(.RSVP)
        }
        if !whenRows.isEmpty {
            var when = Section(header: "When", footer: nil)
            when.rows = whenRows
            sections.append(when)
        }
        
        var venueRows = [Row]()
        if !event.address.isEmpty {
            venueRows.append(.Address)
        }
        if !event.phone.isEmpty {
            venueRows.append(.Phone)
        }
        if !event.email.isEmpty {
            venueRows.append(.Email)
        }
        if !event.website.isEmpty {
            venueRows.append(.Website)
        }
        if !venueRows.isEmpty {
            var venue = Section(header: "Venue", footer: nil)
            venue.rows = venueRows
            sections.append(venue)
        }
        
        var socialRows = [Row]()
        if !event.twitter.isEmpty {
            socialRows.append(.Twitter)
        }
        if !event.facebook.isEmpty {
            socialRows.append(.Facebook)
        }
        if !event.instagram.isEmpty {
            socialRows.append(.Instagram)
        }
        if !socialRows.isEmpty {
            var social = Section(header: "Social", footer: nil)
            social.rows = socialRows
            sections.append(social)
        }
        tableView.reloadData()
        refreshControl?.endRefreshing()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let row = getTableViewRow(indexPath)
        switch row {
        case .Address:
            cell.imageView?.image = UIImage(named: "location")
            cell.textLabel?.text = event.address
            break;
        case .DressCode:
            cell.textLabel?.text = row.rawValue
            cell.detailTextLabel?.text = event.dressCode?.name
            break;
        case .Email:
            cell.imageView?.image = UIImage(named: "message")
            cell.textLabel?.text = event.email
            break;
        case .End:
            cell.textLabel?.text = row.rawValue
            cell.detailTextLabel?.text = event.end
            break;
        case .Facebook:
            cell.imageView?.image = UIImage(named: "facebook")
            cell.textLabel?.text = event.facebook
            break;
        case .Instagram:
            cell.imageView?.image = UIImage(named: "instagram")
            cell.textLabel?.text = event.instagram
            break;
        case .Phone:
            cell.imageView?.image = UIImage(named: "phone")
            cell.textLabel?.text = event.phone
            break;
        case .RSVP:
            cell.textLabel?.text = row.rawValue
            cell.detailTextLabel?.text = event.rsvp
            break;
        case .Start:
            cell.textLabel?.text = row.rawValue
            cell.detailTextLabel?.text = event.start
            break;
        case .Twitter:
            cell.imageView?.image = UIImage(named: "twitter")
            cell.textLabel?.text = event.twitter
            break;
        case .Type:
            cell.textLabel?.text = row.rawValue
            cell.detailTextLabel?.text = event.eventType?.name
            break;
        case .Website:
            cell.imageView?.image = UIImage(named: "link")
            cell.textLabel?.text = event.website
            break;
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = getTableViewRow(indexPath)
        switch row {
        case .Address:
            openMaps(event.address)
            break;
        case .DressCode:
            break;
        case .Email:
            openEmail(event.email)
            break;
        case .End:
            break;
        case .Facebook:
            openFacebookPage(event.facebook)
            break;
        case .Instagram:
            openInstagramWithHastag(event.instagram)
            break;
        case .Phone:
            openPhone(event.phone)
            break;
        case .RSVP:
            break;
        case .Start:
            break;
        case .Twitter:
            openTwitterWithHashtag(event.twitter)
            break;
        case .Type:
            break;
        case .Website:
            openURL(event.website)
            break;
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var highlight = true
        let row = getTableViewRow(indexPath)
        switch row {
        case .Address:
            highlight = !event.address.isEmpty
            break;
        case .DressCode:
            highlight = false
            break;
        case .Email:
            highlight = !event.email.isEmpty
            break;
        case .End:
            highlight = false
            break;
        case .Facebook:
            highlight = !event.facebook.isEmpty
            break;
        case .Instagram:
            highlight = !event.instagram.isEmpty
            break;
        case .Phone:
            highlight = !event.phone.isEmpty
            break;
        case .RSVP:
            highlight = false
            break;
        case .Start:
            highlight = false
            break;
        case .Twitter:
            highlight = !event.twitter.isEmpty
            break;
        case .Type:
            highlight = false
            break;
        case .Website:
            highlight = !event.website.isEmpty
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

//
//  GuestDetailTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/29/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class GuestDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: - Enums
    
    enum Row: String {
        case RSVP
        
        // Contact
        case Address
        case Phone
        case Email
        case Website
        
        // Social
        case Twitter
        case Facebook
        case Instagram
        
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
    
    let segueEventEdit = "segueGuestEdit"
    
    var guest: Guest!
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "didTapEditButton:")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        reload()
        navigationController?.setToolbarHidden(true, animated: false)
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
        if row == .ActionDelete {
            let cell = tableView.dequeueReusableCellWithIdentifier("labelCell", forIndexPath: indexPath) as! LabelTableViewCell
            cell.label.textColor = UIColor.redColor()
            cell.label.text = "Delete Guest"
            returnCell = cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            returnCell = cell
            switch row {
            case .Address:
                cell.imageView?.image = UIImage(named: "location")
                cell.textLabel?.text = guest.address
                break;
            case .Email:
                cell.imageView?.image = UIImage(named: "message")
                cell.textLabel?.text = guest.email
                break;
            case .Facebook:
                cell.imageView?.image = UIImage(named: "facebook")
                cell.textLabel?.text = guest.facebook
                break;
            case .Instagram:
                cell.imageView?.image = UIImage(named: "instagram")
                cell.textLabel?.text = guest.instagram
                break;
            case .Phone:
                cell.imageView?.image = UIImage(named: "phone")
                cell.textLabel?.text = guest.phone
                break;
            case .RSVP:
                cell.textLabel?.text = "RSVP"
                cell.detailTextLabel?.text = guest.rsvpType?.name
                break;
            case .Twitter:
                cell.imageView?.image = UIImage(named: "twitter")
                cell.textLabel?.text = guest.twitter
                break;
            case .Website:
                cell.imageView?.image = UIImage(named: "link")
                cell.textLabel?.text = guest.website
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
            guest.event.deleteGuests([guest], completionHandler: { (error) -> Void in
                guard error == nil else {
                    self.presentSimpleAlert("Unable to delete guests", message: error?.localizedDescription)
                    return
                }
                self.navigationController?.popViewControllerAnimated(true)
            })
            break;
        case .Address:
            openMaps(guest.address)
            break;
        case .Email:
            openEmail(guest.email)
            break;
        case .Facebook:
            openFacebookPage(guest.facebook)
            break;
        case .Instagram:
            openInstagramWithHastag(guest.instagram)
            break;
        case .Phone:
            openPhone(guest.phone)
            break;
        case .RSVP:
            break;
        case .Twitter:
            openTwitterWithHashtag(guest.twitter)
            break;
        case .Website:
            openURL(guest.website)
            break;
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var highlight = true
        let row = getTableViewRow(indexPath)
        switch row {
        case .ActionDelete:
            break;
        case .Address:
            highlight = !guest.address.isEmpty
            break;
        case .Email:
            highlight = !guest.email.isEmpty
            break;
        case .Facebook:
            highlight = !guest.facebook.isEmpty
            break;
        case .Instagram:
            highlight = !guest.instagram.isEmpty
            break;
        case .Phone:
            highlight = !guest.phone.isEmpty
            break;
        case .RSVP:
            highlight = false
            break;
        case .Twitter:
            highlight = !guest.twitter.isEmpty
            break;
        case .Website:
            highlight = !guest.website.isEmpty
            break;
        }
        return highlight
    }
    
    func getTableViewRow(indexPath: NSIndexPath) -> Row {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    // MARK: - Refresh
    
    func refresh() {
        eventPlanner.getGuest(guest) { (error, guest) -> Void in
            guard error == nil else {
                self.presentSimpleAlert("Refresh Error", message: error?.localizedDescription)
                return
            }
            self.guest = guest
            self.reload()
        }
    }
    
    func reload() {
        title = guest.name
        sections = [Section]()
        
        var basicRows = [Row]()
        if let _ = guest.rsvpType {
            basicRows.append(.RSVP)
        }
        if !basicRows.isEmpty {
            var basic = Section(header: nil, footer: nil)
            basic.rows = basicRows
            sections.append(basic)
        }
        
        var contactRows = [Row]()
        if !guest.address.isEmpty {
            contactRows.append(.Address)
        }
        if !guest.phone.isEmpty {
            contactRows.append(.Phone)
        }
        if !guest.email.isEmpty {
            contactRows.append(.Email)
        }
        if !guest.website.isEmpty {
            contactRows.append(.Website)
        }
        if !contactRows.isEmpty {
            var contact = Section(header: "Contact", footer: nil)
            contact.rows = contactRows
            sections.append(contact)
        }
        
        var socialRows = [Row]()
        if !guest.twitter.isEmpty {
            socialRows.append(.Twitter)
        }
        if !guest.facebook.isEmpty {
            socialRows.append(.Facebook)
        }
        if !guest.instagram.isEmpty {
            socialRows.append(.Instagram)
        }
        if !socialRows.isEmpty {
            var social = Section(header: "Social", footer: nil)
            social.rows = socialRows
            sections.append(social)
        }
        
        var actionRows = [Row]()
        actionRows.append(.ActionDelete)
        var actions = Section(header: nil, footer: nil)
        actions.rows = actionRows
        self.sections.append(actions)
        
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Actions
    
    func didTapEditButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier(segueEventEdit, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == segueEventEdit {
            if let navigator = segue.destinationViewController as? UINavigationController {
                if let controller = navigator.viewControllers[0] as? GuestEditTableViewController {
                    controller.editGuest = guest
                    controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: controller, action: "didTapCancelButton:")
                    controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: controller, action: "didTapSaveButton:")
                }
            }
        }
    }
    
}
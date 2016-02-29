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
    
    var person: Guest!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "getPerson", forControlEvents: UIControlEvents.ValueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "didTapEditButton:")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: false)
        getPerson()
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
            cell.textLabel?.text = person.address
            break;
        case .Email:
            cell.imageView?.image = UIImage(named: "message")
            cell.textLabel?.text = person.email
            break;
        case .Facebook:
            cell.imageView?.image = UIImage(named: "facebook")
            cell.textLabel?.text = person.facebook
            break;
        case .Instagram:
            cell.imageView?.image = UIImage(named: "instagram")
            cell.textLabel?.text = person.instagram
            break;
        case .Phone:
            cell.imageView?.image = UIImage(named: "phone")
            cell.textLabel?.text = person.phone
            break;
        case .RSVP:
            cell.textLabel?.text = "Hello"
            break;
        case .Twitter:
            cell.imageView?.image = UIImage(named: "twitter")
            cell.textLabel?.text = person.twitter
            break;
        case .Website:
            cell.imageView?.image = UIImage(named: "link")
            cell.textLabel?.text = person.website
            break;
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = getTableViewRow(indexPath)
        switch row {
        case .Address:
            openMaps(person.address!)
            break;
        case .Email:
            openEmail(person.email!)
            break;
        case .Facebook:
            openFacebookPage(person.facebook!)
            break;
        case .Instagram:
            openInstagramWithHastag(person.instagram!)
            break;
        case .Phone:
            openPhone(person.phone!)
            break;
        case .RSVP:
            break;
        case .Twitter:
            openTwitterWithHashtag(person.twitter!)
            break;
        case .Website:
            openURL(person.website!)
            break;
        }
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        var highlight = true
        let row = getTableViewRow(indexPath)
        switch row {
        case .Address:
            highlight = person.address == nil ? false : !person.address!.isEmpty
            break;
        case .Email:
            highlight = person.email == nil ? false : !person.email!.isEmpty
            break;
        case .Facebook:
            highlight = person.facebook == nil ? false : !person.facebook!.isEmpty
            break;
        case .Instagram:
            highlight = person.instagram == nil ? false : !person.instagram!.isEmpty
            break;
        case .Phone:
            highlight = person.phone == nil ? false : !person.phone!.isEmpty
            break;
        case .RSVP:
            highlight = false
            break;
        case .Twitter:
            highlight = person.twitter == nil ? false : !person.twitter!.isEmpty
            break;
        case .Website:
            highlight = person.website == nil ? false : !person.website!.isEmpty
            break;
        }
        return highlight
    }
    
    // MARK: - Helper methods
    
    func getPerson() {
        print("implement getPerson")
    }
    
    func getRows() {
        title = person.name
        sections = [Section]()
        
        var basicRows = [Row]()
        if let _ = person.rsvp {
            basicRows.append(.RSVP)
        }
        if !basicRows.isEmpty {
            var basic = Section(header: nil, footer: nil)
            basic.rows = basicRows
            sections.append(basic)
        }
        
        var contactRows = [Row]()
        if let address = person.address {
            if !address.isEmpty {
                contactRows.append(.Address)
            }
        }
        if let phone = person.phone {
            if !phone.isEmpty {
                contactRows.append(.Phone)
            }
        }
        if let email = person.email {
            if !email.isEmpty {
                contactRows.append(.Email)
            }
        }
        if let website = person.website {
            if !website.isEmpty {
                contactRows.append(.Website)
            }
        }
        
        var socialRows = [Row]()
        if let twitter = person.twitter {
            if !twitter.isEmpty {
                socialRows.append(.Twitter)
            }
        }
        if let facebook = person.facebook {
            if !facebook.isEmpty {
                socialRows.append(.Facebook)
            }
        }
        if let instagram = person.instagram {
            if !instagram.isEmpty {
                socialRows.append(.Instagram)
            }
        }
        if !socialRows.isEmpty {
            var social = Section(header: "Social", footer: nil)
            social.rows = socialRows
            sections.append(social)
        }
        tableView.reloadData()
        refreshControl?.endRefreshing()
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
        /*
        if segue.identifier == segueEventEdit {
            if let navigator = segue.destinationViewController as? UINavigationController {
                if let controller = navigator.viewControllers[0] as? EventEditTableViewController {
                    controller.editEvent = event
                    controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: controller, action: "didTapCancelButton:")
                    controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: controller, action: "didTapSaveButton:")
                }
            }
        }
        */
    }
    
}
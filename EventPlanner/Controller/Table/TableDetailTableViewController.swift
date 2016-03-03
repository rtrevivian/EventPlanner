//
//  TableDetailTableViewController.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/2/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import UIKit

class TableDetailTableViewController: UITableViewController {
    
    // MARK: - Enums
    
    enum Row: String {
        case Seats, Guests
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
    
    let segueEventEdit = "segueTableEdit"
    
    var table: Table!
    
    var sections = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "didTapEditButton:")
        navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
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
        case .Guests:
            cell.textLabel?.text = "Guests"
            cell.detailTextLabel?.text = table.assigned.description
            break;
        case .Seats:
            cell.textLabel?.text = "Seats"
            cell.detailTextLabel?.text = table.seats.description
            break;
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func getTableViewRow(indexPath: NSIndexPath) -> Row {
        return sections[indexPath.section].rows[indexPath.row]
    }
    
    // MARK: - Refresh
    
    func refresh() {
        eventPlanner.getTable(table) { (table) -> Void in
            self.table = table
            self.reload()
        }
    }
    
    func reload() {
        title = table.name
        
        sections = [Section]()
        
        var basicRows = [Row]()
        basicRows.append(.Seats)
        basicRows.append(.Guests)
        if !basicRows.isEmpty {
            var basic = Section(header: nil, footer: nil)
            basic.rows = basicRows
            sections.append(basic)
        }
        
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
                if let controller = navigator.viewControllers[0] as? TableEditTableViewController {
                    controller.editTable = table
                    controller.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: controller, action: "didTapCancelButton:")
                    controller.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: controller, action: "didTapSaveButton:")
                }
            }
        }
    }
}

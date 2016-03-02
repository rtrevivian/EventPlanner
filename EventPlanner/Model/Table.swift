//
//  Table.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/2/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class Table: NSObject {
    
    enum Change: String {
        case
        TableChanged,
        TableEventChanged,
        TableNameChanged,
        TableSeatsChanged
    }
    
    var entityId: String?
    var metadata: KCSMetadata?
    
    var event: Event! {
        didSet {
            postNotifications(Change.TableEventChanged.rawValue)
        }
    }
    
    var name = String() {
        didSet {
            postNotifications(Change.TableNameChanged.rawValue)
        }
    }
    
    var seats = 8 {
        didSet {
            postNotifications(Change.TableSeatsChanged.rawValue)
        }
    }
    
    // MARK: - Clone
    
    func clone(table: Table) {
        entityId = table.entityId
        metadata = table.metadata
        
        event = table.event
        name = table.name
        seats = table.seats
    }
    
    // MARK: - Notifications
    
    func postNotifications(notification: String) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: notification, object: self))
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: Change.TableChanged.rawValue, object: self))
    }
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId,
            "metadata" : KCSEntityKeyMetadata,
            "event" : "event",
            "name" : "name",
            "seats" : "seats"
        ]
    }
    
    static override func kinveyPropertyToCollectionMapping() -> [NSObject : AnyObject]! {
        return [
            "event" : "Events"
        ]
    }
    
    static override func kinveyObjectBuilderOptions() -> [NSObject : AnyObject]! {
        return [
            KCS_REFERENCE_MAP_KEY : [
                "event" : Event.self
            ]
        ]
    }
    
}

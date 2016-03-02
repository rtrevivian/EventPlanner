//
//  Seat.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/2/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class Seat: NSObject {
    
    enum Change: String {
        case
        SeatChanged,
        SeatTableChanged,
        SeatGuestChanged,
        SeatNameChanged
    }
    
    var entityId: String?
    var metadata: KCSMetadata?
    
    var guest: Guest! {
        didSet {
            postNotifications(Change.SeatGuestChanged.rawValue)
        }
    }
    
    var name = String() {
        didSet {
            postNotifications(Change.SeatNameChanged.rawValue)
        }
    }
    
    var table: Event! {
        didSet {
            postNotifications(Change.SeatTableChanged.rawValue)
        }
    }
    
    // MARK: - Notifications
    
    func postNotifications(notification: String) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: notification, object: self))
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: Change.SeatChanged.rawValue, object: self))
    }
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId,
            "metadata" : KCSEntityKeyMetadata,
            "guest" : "guest",
            "name" : "name",
            "table" : "table"
        ]
    }
    
    static override func kinveyPropertyToCollectionMapping() -> [NSObject : AnyObject]! {
        return [
            "guest" : "Guests",
            "table" : "Tables"
        ]
    }
    
    static override func kinveyObjectBuilderOptions() -> [NSObject : AnyObject]! {
        return [
            KCS_REFERENCE_MAP_KEY : [
                "guest" : Guest.self,
                "table" : Table.self
            ]
        ]
    }
    
}

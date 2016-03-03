//
//  Guest.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class Guest: NSObject {
    
    enum Change: String {
        case
        GuestChanged,
        GuestEventChanged,
        GuestNameChanged,
        GuestRSVPChanged,
        GuestAddressChanged,
        GuestPhoneChanged,
        GuestEmailChanged,
        GuestWebsiteChanged,
        GuestFacebookChanged,
        GuestTwitterChanged,
        GuestInstagramChanged,
        GuestSeatChanged
    }
    
    var entityId: String?
    var metadata: KCSMetadata?
    
    var event: Event! {
        didSet {
            postNotifications(Change.GuestEventChanged.rawValue)
        }
    }
    
    var seat: Seat? {
        didSet {
            postNotifications(Change.GuestSeatChanged.rawValue)
        }
    }
    
    var name = String() {
        didSet {
            postNotifications(Change.GuestNameChanged.rawValue)
        }
    }
    
    var rsvp = String() {
        didSet {
            postNotifications(Change.GuestRSVPChanged.rawValue)
        }
    }
    
    var address = String() {
        didSet {
            postNotifications(Change.GuestAddressChanged.rawValue)
        }
    }
    
    var phone = String() {
        didSet {
            postNotifications(Change.GuestPhoneChanged.rawValue)
            
        }
    }
    
    var email = String() {
        didSet {
            postNotifications(Change.GuestEmailChanged.rawValue)
            
        }
    }
    
    var website = String() {
        didSet {
            postNotifications(Change.GuestWebsiteChanged.rawValue)
            
        }
    }
    
    var facebook = String() {
        didSet {
            postNotifications(Change.GuestFacebookChanged.rawValue)
            
        }
    }
    
    var twitter = String() {
        didSet {
            postNotifications(Change.GuestTwitterChanged.rawValue)
            
        }
    }
    
    var instagram = String() {
        didSet {
            postNotifications(Change.GuestInstagramChanged.rawValue)
        }
    }
    
    // MARK: - Notifications
    
    func postNotifications(notification: String) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: notification, object: self))
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: Change.GuestChanged.rawValue, object: self))
    }
    
    // MARK: - Clone
    
    func clone(person: Guest) {
        entityId = person.entityId
        metadata = person.metadata
        
        event = person.event
        seat = person.seat
        
        name = person.name
        rsvp = person.rsvp
        address = person.address
        phone = person.phone
        email = person.email
        website = person.website
        facebook = person.facebook
        twitter = person.twitter
        instagram = person.instagram
    }
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "metadata" : KCSEntityKeyMetadata, //optional _metadata field
            
            "event" : "event",
            "seat" : "seat",
            
            "name" : "name",
            "rsvp" : "rsvp",
            "address" : "address",
            "phone" : "phone",
            "email" : "email",
            "website" : "website",
            "facebook" : "facebook",
            "twitter" : "twitter",
            "instagram" : "instagram",
        ]
    }
    
    static override func kinveyPropertyToCollectionMapping() -> [NSObject : AnyObject]! {
        return [
            "event" : "Events",
            "seat" : "Seats"
        ]
    }
    
    static override func kinveyObjectBuilderOptions() -> [NSObject : AnyObject]! {
        return [
            KCS_REFERENCE_MAP_KEY : [
                "event" : Event.self,
                "seat" : Seat.self
            ]
        ]
    }
    
}

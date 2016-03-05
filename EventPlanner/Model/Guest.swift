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
        GuestRSVPTypeChanged,
        GuestNameChanged,
        GuestAddressChanged,
        GuestPhoneChanged,
        GuestEmailChanged,
        GuestWebsiteChanged,
        GuestFacebookChanged,
        GuestTwitterChanged,
        GuestInstagramChanged
    }
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    var entityId: String?
    var metadata: KCSMetadata?
    
    var event: Event! {
        didSet {
            postNotifications(Change.GuestEventChanged.rawValue)
        }
    }
    
    var rsvpType: RSVPType? {
        didSet {
            postNotifications(Change.GuestRSVPTypeChanged.rawValue)
        }
    }
    
    var name = String() {
        didSet {
            postNotifications(Change.GuestNameChanged.rawValue)
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
    
    func clone(guest: Guest) {
        entityId = guest.entityId
        metadata = guest.metadata
        
        event = guest.event
        rsvpType = guest.rsvpType
        
        name = guest.name
        address = guest.address
        phone = guest.phone
        email = guest.email
        website = guest.website
        facebook = guest.facebook
        twitter = guest.twitter
        instagram = guest.instagram
    }
    
    // MARK: - Update
    
    func deleteSelf(cancel: (() -> Void)?, confirm: (() -> Void)?) {
        self.eventPlanner.deleteGuests([self], completionHandler: { (success) -> Void in
            if success {
                if let index = self.event.guests.indexOf(self) {
                    self.event.guests.removeAtIndex(index)
                }
                confirm?()
            } else {
                cancel?()
            }
        })
    }
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId,
            "metadata" : KCSEntityKeyMetadata,

            "event" : "event",
            "rsvpType" : "rsvpType",
            
            "name" : "name",
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
            "rsvpType" : "RSVPTypes"
        ]
    }
    
    static override func kinveyObjectBuilderOptions() -> [NSObject : AnyObject]! {
        return [
            KCS_REFERENCE_MAP_KEY : [
                "event" : Event.self,
                "rsvpType" : RSVPType.self
            ]
        ]
    }
    
}

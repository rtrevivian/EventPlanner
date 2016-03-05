//
//  Event.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class Event: NSObject {
    
    enum Change: String {
        case
        EventChanged,
        EventTypeChanged,
        EventDressCodeChanged,
        EventUserChanged,
        EventStartDateChanged,
        EventEndDateChanged,
        EventRSVPDateChanged,
        EventNameChanged,
        EventAddressChanged,
        EventPhoneChanged,
        EventEmailChanged,
        EventWebsiteChanged,
        EventFacebookChanged,
        EventTwitterChanged,
        EventInstagramChanged,
        EventTablesChanged,
        EventGuestsChanged,
        EventRSVPsChanged
    }
    
    static var dateFormatter = NSDateFormatter()
    
    lazy var eventPlanner: EventPlanner = {
        return EventPlanner.sharedInstance()
    }()
    
    var entityId: String?
    var metadata: KCSMetadata?
    
    var eventType: EventType? {
        didSet {
            postNotifications(Change.EventTypeChanged.rawValue)
        }
    }
    
    var dressCode: DressCode? {
        didSet {
            postNotifications(Change.EventDressCodeChanged.rawValue)
        }
    }
    var user: KCSUser! {
        didSet {
            postNotifications(Change.EventUserChanged.rawValue)
        }
    }
    
    var startDate: NSDate? {
        didSet {
            if startDate != nil  {
                if endDate != nil {
                    if startDate?.timeIntervalSince1970 > endDate?.timeIntervalSince1970 {
                        endDate = nil
                    }
                }
                if rsvpDate != nil {
                    if startDate?.timeIntervalSince1970 < rsvpDate?.timeIntervalSince1970 {
                        rsvpDate = nil
                    }
                }
            } else {
                endDate = nil
                rsvpDate = nil
            }
            postNotifications(Change.EventStartDateChanged.rawValue)
        }
    }
    
    var endDate: NSDate? {
        didSet {
            postNotifications(Change.EventEndDateChanged.rawValue)
        }
    }
    
    var rsvpDate: NSDate? {
        didSet {
            postNotifications(Change.EventRSVPDateChanged.rawValue)
        }
    }
    
    var start: String? {
        get {
            return startDate == nil ? nil : Event.dateFormatter.stringFromDate(startDate!)
        }
    }
    
    var end: String? {
        get {
            return endDate == nil ? nil : Event.dateFormatter.stringFromDate(endDate!)
        }
    }
    
    var rsvp: String? {
        get {
            return rsvpDate == nil ? nil : Event.dateFormatter.stringFromDate(rsvpDate!)
        }
    }
    
    var name = String() {
        didSet {
            postNotifications(Change.EventNameChanged.rawValue)
        }
    }
    
    var address = String() {
        didSet {
            postNotifications(Change.EventAddressChanged.rawValue)
        }
    }
    
    var phone = String() {
        didSet {
            postNotifications(Change.EventPhoneChanged.rawValue)
        }
    }
    
    var email = String() {
        didSet {
            postNotifications(Change.EventEmailChanged.rawValue)
        }
    }
    
    var website = String() {
        didSet {
            postNotifications(Change.EventWebsiteChanged.rawValue)
        }
    }
    
    var facebook = String() {
        didSet {
            postNotifications(Change.EventFacebookChanged.rawValue)
        }
    }
    
    var twitter = String() {
        didSet {
            postNotifications(Change.EventTwitterChanged.rawValue)
        }
    }
    
    var instagram = String() {
        didSet {
            postNotifications(Change.EventInstagramChanged.rawValue)
        }
    }
    
    var guests = [Guest]() {
        didSet {
            var rsvps = [Guest]()
            for guest in guests {
                if let _ = guest.rsvpType {
                    rsvps.append(guest)
                }
            }
            self.rsvps = rsvps
            postNotifications(Change.EventGuestsChanged.rawValue)
        }
    }
    
    var rsvps = [Guest]() {
        didSet {
            postNotifications(Change.EventRSVPsChanged.rawValue)
        }
    }
    
    override init() {
        super.init()
        
        Event.dateFormatter.dateStyle = .MediumStyle
        Event.dateFormatter.timeStyle = .ShortStyle
    }
    
    // MARK: - Clone
    
    func clone(event: Event) {
        entityId = event.entityId
        metadata = event.metadata
        name = event.name
        eventType = event.eventType
        dressCode = event.dressCode
        endDate = event.endDate
        rsvpDate = event.rsvpDate
        startDate = event.startDate
        facebook = event.facebook
        twitter = event.twitter
        instagram = event.instagram
        address = event.address
        phone = event.phone
        email = event.email
        website = event.website
        user = event.user
    }
    
    // MARK: - Update
    
    func deleteSelf(cancel: (() -> Void)?, confirm: (() -> Void)?) -> AlertViewController {
        let alert = AlertViewController(title: "Delete Event", message: "This cannot be undone", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            cancel?()
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
            self.eventPlanner.deleteEvents([self], completionHandler: { (success) -> Void in
                if success {
                    if let index = self.eventPlanner.events.indexOf(self) {
                        self.eventPlanner.events.removeAtIndex(index)
                    }
                    confirm?()
                } else {
                    cancel?()
                }
            })
        }))
        return alert
    }
    
    func empty(cancel: (() -> Void)?, confirm: (() -> Void)?) -> AlertViewController {
        let alert = AlertViewController(title: "Remove Guests", message: "This cannot be undone", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) -> Void in
            cancel?()
        }))
        alert.addAction(UIAlertAction(title: "Empty", style: .Destructive, handler: { (action) -> Void in
            self.guests.removeAll()
            confirm?()
        }))
        return alert
    }
    
    func update(completionHandler: (() -> Void)?) {
        eventPlanner.getGuests(self) { (guests) -> Void in
            self.guests = guests
            completionHandler?()
        }
    }
    
    // MARK: - Notifications
    
    func postNotifications(notification: String) {
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: notification, object: self))
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: Change.EventChanged.rawValue, object: self))
    }
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "metadata" : KCSEntityKeyMetadata, //optional _metadata field
            "name" : "name",
                
            "eventType" : "eventType",
            "dressCode" : "dressCode",
            
            "startDate" : "startDate",
            "rsvpDate" : "rsvpDate",
            "endDate" : "endDate",

            "address" : "address",
            "phone" : "phone",
            "email" : "email",
            "website" : "website",
            
            "facebook" : "facebook",
            "twitter" : "twitter",
            "instagram" : "instagram",
            
            "user" : "user"
        ]
    }
    
    static override func kinveyPropertyToCollectionMapping() -> [NSObject : AnyObject]! {
        return [
            "user" : KCSUserCollectionName,
            "eventType" : "EventTypes",
            "dressCode" : "DressCodes",
        ]
    }
    
    static override func kinveyObjectBuilderOptions() -> [NSObject : AnyObject]! {
        return [
            KCS_REFERENCE_MAP_KEY : [
                "user" : KCSUser.self,
                "eventType" : EventType.self,
                "dressCode" : DressCode.self
            ]
        ]
    }
    
}

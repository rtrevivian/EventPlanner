//
//  Event.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class Event: NSObject {
    
    static var dateFormatter = NSDateFormatter()
    
    var entityId: String?
    var metadata: KCSMetadata?
    
    var name: String?
    var eventType: EventType? {
        didSet {
            eventTypeID = eventType?.entityId
        }
    }
    
    var dressCode: DressCode? {
        didSet {
            dressCodeID = dressCode?.entityId
        }
    }
    
    var eventTypeID: String? {
        didSet {
            if eventTypeID != nil && eventType == nil {
                for object in EventPlanner.sharedInstance().eventTypes {
                    if object.entityId == eventTypeID {
                        eventType = object
                    }
                }
            }
        }
    }
    
    var dressCodeID: String? {
        didSet {
            if dressCodeID != nil && dressCode == nil {
                for object in EventPlanner.sharedInstance().dressCodes {
                    if object.entityId == dressCodeID {
                        dressCode = object
                    }
                }
            }
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
        }
    }
    
    var endDate: NSDate?
    var rsvpDate: NSDate?
    
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
    
    var address: String?
    var phone: String?
    var email: String?
    var website: String?
    
    var facebook: String?
    var twitter: String?
    var instagram: String?
    
    var guests = [Guest]()
    
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
        guests = event.guests
    }
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "metadata" : KCSEntityKeyMetadata, //optional _metadata field
            "name" : "name",
            
            "eventTypeID" : "eventTypeID",
            "dressCodeID" : "dressCodeID",
            
            "startDate" : "startDate",
            "rsvpDate" : "rsvpDate",
            "endDate" : "endDate",

            "address" : "address",
            "phone" : "phone",
            "email" : "email",
            "website" : "website",
            
            "facebook" : "facebook",
            "twitter" : "twitter",
            "instagram" : "instagram"
        ]
    }
    
}

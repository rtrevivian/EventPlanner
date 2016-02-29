//
//  Attendee.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/20/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class Guest: NSObject {
    
    var entityId: String? //Kinvey entity _id
    var metadata: KCSMetadata? //Kinvey metadata, optional
    
    var name: String?
    var rsvp: String?
    
    var address: String?
    var phone: String?
    var email: String?
    var website: String?
    
    var facebook: String?
    var twitter: String?
    var instagram: String?
    
    // MARK: - Clone
    
    func clone(person: Guest) {
        entityId = person.entityId
        metadata = person.metadata
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
            "name" : "name"
        ]
    }
    
}
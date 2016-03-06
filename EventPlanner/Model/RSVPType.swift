//
//  RSVP.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/1/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class RSVPType: NSObject {
    
    // MARK: - Properties
    
    var entityId: String?
    var metadata: KCSMetadata?
    
    var name = String()
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId,
            "metadata" : KCSEntityKeyMetadata,
            "name" : "name"
        ]
    }
    
}

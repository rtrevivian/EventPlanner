//
//  RSVPType.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/26/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class RSVPType: NSObject {
    
    var entityId: String? //Kinvey entity _id
    var metadata: KCSMetadata? //Kinvey metadata, optional
    
    var name = String()
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "metadata" : KCSEntityKeyMetadata, //optional _metadata field
            "name" : "name"
        ]
    }
    
}
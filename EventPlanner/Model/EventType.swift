//
//  EventType.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/25/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class EventType: NSObject {
    
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

//
//  DressCode.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/25/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class DressCode: NSObject {
    
    // MARK: - Properties
    
    var entityId: String?
    var name = String()
    
    // MARK: - Kinvey
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId,
            "name" : "name"
        ]
    }
    
}

//
//  Venue.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/21/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation
import MapKit

class ContactInfo: NSObject, MKAnnotation {
    
    var dictionary: NSDictionary! {
        didSet {
            print("dictionary", dictionary)
        }
    }
    
    var latitude: Double?
    var longitude: Double?
    
    var address = String()
    var phone = String()
    var email = String()
    var website = String()
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
    }
    
}

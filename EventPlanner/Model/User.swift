//
//  User.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 3/4/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
class User: NSManagedObject {
    
    // MARK: - Structs
    
    struct Keys {
        static let Username = "username"
        static let Password = "password"
    }
    
    struct Notifications {
        static let Deleted = "UserDeleted"
    }
    
    // MARK: - Properties
    
    @NSManaged var username: String
    @NSManaged var password: String
    
    // MARK: - Initialization
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)
        super.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        username = dictionary[Keys.Username] as! String
        password = dictionary[Keys.Password] as! String
    }
    
    func deleteUser() {
        managedObjectContext!.deleteObject(self)
        do {
            try managedObjectContext?.save()
            NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: Notifications.Deleted, object: self))
        } catch {
            print("Error deleteUser:", error)
        }
    }
    
}
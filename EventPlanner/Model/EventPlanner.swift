//
//  EventPlanner.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/25/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation
import CoreData

class EventPlanner {
    
    // MARK: - Properties
    
    class func sharedInstance() -> EventPlanner {
        struct Static {
            static let instance = EventPlanner()
        }
        return Static.instance
    }
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    let dressCodesStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "DressCodes",
        KCSStoreKeyCollectionTemplateClass : DressCode.self
        ])
    
    let eventsStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Events",
        KCSStoreKeyCollectionTemplateClass : Event.self
        ])
    
    let eventTypesStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "EventTypes",
        KCSStoreKeyCollectionTemplateClass : EventType.self
        ])
    
    let guestsStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Guests",
        KCSStoreKeyCollectionTemplateClass : Guest.self
        ])
    
    let rsvpTypesStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "RSVPTypes",
        KCSStoreKeyCollectionTemplateClass : RSVPType.self
        ])
    
    // MARK: - Static data sources
    
    var dressCodes = [DressCode]()
    var eventTypes = [EventType]()
    var rsvpTypes = [RSVPType]()
    
    // MARK: - Dynamic data sources
    
    var user: User?
    var events = [Event]()
    var networking = false {
        didSet {
             UIApplication.sharedApplication().networkActivityIndicatorVisible = networking
        }
    }
    
    func start(completionHandler: ((Bool) -> Void)?) {
        KCSClient.sharedClient().initializeKinveyServiceForAppKey(
            "kid_-y4qiUCFRl",
            withAppSecret: "42d1c89bd3c941088b44f571025a5856",
            usingOptions: nil
        )
        KCSPing.pingKinveyWithBlock { (result: KCSPingResult!) -> Void in
            completionHandler?(result.pingWasSuccessful)
        }
    }
    
    // MARK: - User
    
    func login(username: String, password: String, completionHandler: ((AnyObject?) -> Void)?) {
        networking = true
        KCSUser.loginWithUsername(username, password: password) { (user, error, result) -> Void in
            self.networking = false
            guard error == nil else {
                print("login error:", error.localizedDescription)
                completionHandler?(error.localizedDescription)
                return
            }
            let _ = User(dictionary: [User.Keys.Username: username, User.Keys.Password: password], context: CoreDataStackManager.sharedInstance().managedObjectContext)
            do {
                try CoreDataStackManager.sharedInstance().managedObjectContext.save()
            } catch {
                print("Error saving user:", error)
            }
            self.getEventTypes { (success, eventTypes) -> Void in
                if success {
                    self.eventTypes = eventTypes!
                    self.getDressCodes({ (success, dressCodes) -> Void in
                        if success {
                            self.dressCodes = dressCodes!
                            self.getRSVPTypes({ (success, rsvpTypes) -> Void in
                                if success {
                                    self.rsvpTypes = rsvpTypes!
                                    completionHandler?(nil)
                                } else {
                                    completionHandler?("Unable to load RSVP types")
                                }
                            })
                        } else {
                            completionHandler?("Unable to load dress codes")
                        }
                    })
                } else {
                    completionHandler?("Unable to load event types")
                }
            }
        }
        
    }
    
    func logout() {
        if KCSUser.activeUser() != nil {
            KCSUser.activeUser().logout()
            events.removeAll()
        }
        deleteUsers()
    }
    
    func fetchUsers(completionHandler: (() -> Void)?) -> [User] {
        let fetchRequest = NSFetchRequest(entityName: "User")
        var results = [AnyObject]()
        do {
            results = try self.sharedContext.executeFetchRequest(fetchRequest)
        } catch {
            print("Error fetching users:", error)
        }
        let users = results as! [User]
        user = users.isEmpty ? nil : users[0]
        completionHandler?()
        return users
    }
    
    func deleteUsers() {
        for user in fetchUsers(nil) {
            user.deleteUser()
        }
        user = nil
    }
    
    func signUp(username: String, password: String, completionHandler: ((NSError?) -> Void)?) {
        networking = true
        KCSUser.userWithUsername(username, password: password, fieldsAndValues: nil) { (user, error, result) -> Void in
            self.networking = false
            guard error == nil else {
                print("signUp error:", error)
                completionHandler?(error)
                return
            }
            completionHandler?(nil)
        }
    }
    
    // MARK: - Static data types
    
    func getDressCodes(completionHandler: ((Bool, [DressCode]?) -> Void)?) {
        networking = true
        dressCodesStore.queryWithQuery(KCSQuery(), withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("getDressCodes error:", error)
                completionHandler?(false, nil)
                return
            }
            completionHandler?(true, objects as? [DressCode])
            }, withProgressBlock: nil)
    }
    
    func getEventTypes(completionHandler: ((Bool, [EventType]?) -> Void)?) {
        networking = true
        let query = KCSQuery()
        let dataSort = KCSQuerySortModifier(field: "name", inDirection: KCSSortDirection.Ascending)
        query.addSortModifier(dataSort)
        eventTypesStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("getEventTypes error:", error)
                completionHandler?(false, nil)
                return
            }
            completionHandler?(true, objects as? [EventType])
            }, withProgressBlock: nil)
    }
    
    func getRSVPTypes(completionHandler: ((Bool, [RSVPType]?) -> Void)?) {
        networking = true
        let query = KCSQuery()
        let dataSort = KCSQuerySortModifier(field: "name", inDirection: KCSSortDirection.Ascending)
        query.addSortModifier(dataSort)
        rsvpTypesStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("getRSVPTypes error:", error)
                completionHandler?(false, nil)
                return
            }
            completionHandler?(true, objects as? [RSVPType])
            }, withProgressBlock: nil)
    }
    
    // MARK: - Event
    
    func deleteEvents(events: [Event], completionHandler: ((NSError?) -> Void)?) {
        for event in events {
            deleteGuests(event.guests, completionHandler: nil)
        }
        networking = true
        eventsStore.removeObject(events, withDeletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("deleteEvents error:", error)
                completionHandler?(error)
                return
            }
            completionHandler?(nil)
            }, withProgressBlock: nil)
    }
    
    func getEvent(event: Event, completionHandler: ((NSError?, Event?) -> Void)?) {
        networking = true
        let query = KCSQuery(onField: "_id", withExactMatchForValue: event.entityId)
        eventsStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                completionHandler?(error, nil)
                return
            }
            completionHandler?(nil, objects[0] as? Event)
            }, withProgressBlock: nil)
        
        /*
        // BUG: 03/01/15 loadObjectWithID cannot load entities with relational data use queryWithQuery instead
        eventsStore.loadObjectWithID(event.entityId, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                completionHandler?(nil)
                return
            }
            completionHandler?(objects[0] as? Event)
            }, withProgressBlock: nil)
        */
    }
    
    func getEvents(completionHandler: ((NSError?) -> Void)?) {
        networking = true
        let query = KCSQuery(onField: "user._id", withExactMatchForValue: KCSUser.activeUser())
        eventsStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("getEvents error:", error)
                self.events = [Event]()
                completionHandler?(error)
                return
            }
            let events = objects as! [Event]
            for event in events {
                event.update(nil)
            }
            self.events = events
            completionHandler?(nil)
            }, withProgressBlock: nil)
    }
    
    func saveEvents(events: [Event], completionHandler: ((NSError?, [Event]?) -> Void)?) {
        networking = true
        eventsStore.saveObject(events, withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("saveEvents error:", error)
                completionHandler?(error, nil)
                return
            }
            completionHandler?(nil, objects as? [Event])
            }, withProgressBlock: nil)
    }
    
    // MARK: - Guests
    
    func deleteGuests(guests: [Guest], completionHandler: ((NSError?) -> Void)?) {
        networking = true
        guestsStore.removeObject(guests, withDeletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("deleteGuests error:", error)
                completionHandler?(error)
                return
            }
            completionHandler?(nil)
            }, withProgressBlock: nil)
    }
    
    func getGuest(guest: Guest, completionHandler: ((NSError?, Guest?) -> Void)?) {
        networking = true
        let query = KCSQuery(onField: "_id", withExactMatchForValue: guest.entityId)
        guestsStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("getGuest error:", error)
                completionHandler?(error, nil)
                return
            }
            completionHandler?(nil, objects[0] as? Guest)
            }, withProgressBlock: nil)
    }
    
    func getGuests(event: Event, completionHandler: ((NSError?, [Guest]?) -> Void)?) {
        networking = true
        let query = KCSQuery(onField: "event._id", withExactMatchForValue: event.entityId)
        guestsStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("getGuests error:", error)
                completionHandler?(error, [])
                return
            }
            completionHandler?(nil, objects as? [Guest])
            }, withProgressBlock: nil)
    }
    
    func saveGuests(guests: [Guest], completionHandler: ((NSError?, [Guest]?) -> Void)?) {
        networking = true
        guestsStore.saveObject(guests, withCompletionBlock: { (objects, error) -> Void in
            self.networking = false
            guard error == nil else {
                print("saveGuests error:", error)
                completionHandler?(error, nil)
                return
            }
            completionHandler?(nil, objects as? [Guest])
            }, withProgressBlock: nil)
    }
    
}

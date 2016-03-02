//
//  EventPlanner.swift
//  EventPlanner
//
//  Created by Richard Trevivian on 2/25/16.
//  Copyright © 2016 Richard Trevivian. All rights reserved.
//

import Foundation

class EventPlanner {
    
    class func sharedInstance() -> EventPlanner {
        struct Static {
            static let instance = EventPlanner()
        }
        return Static.instance
    }
    
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
    
    let tablesStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Tables",
        KCSStoreKeyCollectionTemplateClass : Table.self
        ])

    
    // MARK: - Static data sources
    
    var dressCodes = [DressCode]()
    var eventTypes = [EventType]()
    var rsvpTypes = [RSVPType]()
    
    // MARK: - Dynamic data sources
    
    var events = [Event]()
    
    func start() {
        KCSClient.sharedClient().initializeKinveyServiceForAppKey(
            "kid_-y4qiUCFRl",
            withAppSecret: "42d1c89bd3c941088b44f571025a5856",
            usingOptions: nil
        )
        KCSPing.pingKinveyWithBlock { (result: KCSPingResult!) -> Void in
            if result.pingWasSuccessful {
                self.getDressCodes()
                self.getEventTypes()
                self.getRSVPTypes()
            } else {
                print("pingKinveyWithBlock failed")
            }
        }
    }
    
    // MARK: - User
    
    func login(username: String, password: String, completionHandler: ((Bool, AnyObject) -> Void)?) {
        KCSUser.loginWithUsername(username, password: password) { (user, error, result) -> Void in
            guard error == nil else {
                print("login error:", error.localizedDescription)
                completionHandler?(false, error.localizedDescription)
                return
            }
            completionHandler?(true, user)
        }
    }
    
    func logout() {
        if KCSUser.activeUser() != nil {
            KCSUser.activeUser().logout()
            events.removeAll()
        }
    }
    
    // MARK: - Static data types
    
    func getDressCodes() {
        dressCodesStore.queryWithQuery(KCSQuery(), withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getDressCodes error:", error)
                return
            }
            self.dressCodes = objects as! [DressCode]
            }, withProgressBlock: nil)
    }
    
    func getEventTypes() {
        eventTypesStore.queryWithQuery(KCSQuery(), withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getEventTypes error:", error)
                return
            }
            self.eventTypes = objects as! [EventType]
            }, withProgressBlock: nil)
    }
    
    func getRSVPTypes() {
        rsvpTypesStore.queryWithQuery(KCSQuery(), withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getRSVPTypes error:", error)
                return
            }
            self.rsvpTypes = objects as! [RSVPType]
            }, withProgressBlock: nil)
    }
    
    // MARK: - Event
    
    func deleteEvents(events: [Event], completionHandler: ((Bool) -> Void)?) {
        eventsStore.removeObject(events, withDeletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("deleteEvents error:", error)
                completionHandler?(false)
                return
            }
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
    func getEvent(event: Event, completionHandler: ((Event?) -> Void)?) {
        let query = KCSQuery(onField: "_id", withExactMatchForValue: event.entityId)
        eventsStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                completionHandler?(nil)
                return
            }
            completionHandler?(objects[0] as? Event)
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
    
    func getEvents(completionHandler: ((Bool) -> Void)?) {
        let query = KCSQuery(onField: "user._id", withExactMatchForValue: KCSUser.activeUser())
        eventsStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getEvents error:", error)
                self.events = [Event]()
                completionHandler?(false)
                return
            }
            let events = objects as! [Event]
            for event in events {
                event.update(nil)
            }
            self.events = events
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
    func saveEvents(events: [Event], completionHandler: ((Bool) -> Void)?) {
        eventsStore.saveObject(events, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("saveEvents error:", error)
                completionHandler?(false)
                return
            }
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
    // MARK: - Guests
    
    func deleteGuests(guests: [Guest], completionHandler: ((Bool) -> Void)?) {
        guestsStore.removeObject(guests, withDeletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("deleteGuests error:", error)
                completionHandler?(false)
                return
            }
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
    func getGuest(guest: Guest, completionHandler: ((Guest?) -> Void)?) {
        let query = KCSQuery(onField: "_id", withExactMatchForValue: guest.entityId)
        guestsStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getGuest error:", error)
                completionHandler?(nil)
                return
            }
            completionHandler?(objects[0] as? Guest)
            }, withProgressBlock: nil)
    }
    
    func getGuests(event: Event, completionHandler: (([Guest]) -> Void)?) {
        let query = KCSQuery(onField: "event._id", withExactMatchForValue: event.entityId)
        guestsStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getGuests error:", error)
                completionHandler?([])
                return
            }
            completionHandler?(objects as! [Guest])
            }, withProgressBlock: nil)
    }
    
    func saveGuests(guests: [Guest], completionHandler: (([Guest]) -> Void)?) {
        guestsStore.saveObject(guests, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("saveGuests error:", error)
                completionHandler?([])
                return
            }
            completionHandler?(objects as! [Guest])
            }, withProgressBlock: nil)
    }
    
    // MARK: - Table
    
    func deleteTables(tables: [Table], completionHandler: ((Bool) -> Void)?) {
        tablesStore.removeObject(tables, withDeletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("deleteTables error:", error)
                completionHandler?(false)
                return
            }
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
    func getTable(table: Table, completionHandler: ((Table?) -> Void)?) {
        let query = KCSQuery(onField: "_id", withExactMatchForValue: table.entityId)
        tablesStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getGuest error:", error)
                completionHandler?(nil)
                return
            }
            completionHandler?(objects[0] as? Table)
            }, withProgressBlock: nil)
    }
    
    func getTables(event: Event, completionHandler: (([Table]) -> Void)?) {
        let query = KCSQuery(onField: "event._id", withExactMatchForValue: event.entityId)
        tablesStore.queryWithQuery(query, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getTables error:", error)
                completionHandler?([])
                return
            }
            completionHandler?(objects as! [Table])
            }, withProgressBlock: nil)
    }
    
    func saveTables(tables: [Table], completionHandler: (([Table]) -> Void)?) {
        tablesStore.saveObject(tables, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("saveTables error:", error)
                completionHandler?([])
                return
            }
            completionHandler?(objects as! [Table])
            }, withProgressBlock: nil)
    }
    
}

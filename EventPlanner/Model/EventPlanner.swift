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
    
    let rsvpTypesStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "RSVPTypes",
        KCSStoreKeyCollectionTemplateClass : RSVPType.self
        ])
    
    let guestsStore = KCSLinkedAppdataStore.storeWithOptions([
        KCSStoreKeyCollectionName : "Guests",
        KCSStoreKeyCollectionTemplateClass : Event.self
        ])
    
    var dressCodes = [DressCode]()
    var events = [Event]()
    var eventTypes = [EventType]()
    var rsvpTypes = [RSVPType]()
    var guests = [Guest]()
    
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
            } else {
                print("pingKinveyWithBlock failed")
            }
        }
    }
    
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
    
    // MARK: - Event methods
    
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
        eventsStore.loadObjectWithID(event.entityId, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getEvents error:", error)
                completionHandler?(nil)
                return
            }
            completionHandler?(objects[0] as? Event)
            }, withProgressBlock: nil)
    }
    
    func getEvents(completionHandler: ((Bool) -> Void)?) {
        eventsStore.queryWithQuery(KCSQuery(), withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getEvents error:", error)
                self.events = [Event]()
                completionHandler?(false)
                return
            }
            self.events = objects as! [Event]
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
    func saveEvents(events: [Event], completionHandler: ((Bool) -> Void)?) {
        eventsStore.saveObject(eventsStore, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("saveEvents error:", error)
                completionHandler?(false)
                return
            }
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
    // MARK: - Guests methods
    
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
    
    func getGuest(guest: Guest, completionHandler: ((Event?) -> Void)?) {
        guestsStore.loadObjectWithID(guest.entityId, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getGuest error:", error)
                completionHandler?(nil)
                return
            }
            completionHandler?(objects[0] as? Event)
            }, withProgressBlock: nil)
    }
    
    func getGuests(completionHandler: ((Bool) -> Void)?) {
        guestsStore.queryWithQuery(KCSQuery(), withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("getGuests error:", error)
                self.events = [Event]()
                completionHandler?(false)
                return
            }
            self.events = objects as! [Event]
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
    func saveGuests(guests: [Guest], completionHandler: ((Bool) -> Void)?) {
        guestsStore.saveObject(guests, withCompletionBlock: { (objects, error) -> Void in
            guard error == nil else {
                print("saveGuests error:", error)
                completionHandler?(false)
                return
            }
            completionHandler?(true)
            }, withProgressBlock: nil)
    }
    
}
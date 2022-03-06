//
//  CoreDataClient.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/22/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import CoreData

class CoreDataClient: LocalStore {    
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        return context
    }()
    
    func clear() {
        // Remove all managed objects from memory
        log.info("Registered objects main:", context: viewContext.registeredObjects.count)
        if viewContext.registeredObjects.count > 0 {
            viewContext.reset()
            log.info("Removing all managed objects from main context:", context: viewContext.registeredObjects.count)
        }
        log.info("Registered objects bg:", context: backgroundContext.registeredObjects.count)
        if backgroundContext.registeredObjects.count > 0 {
            backgroundContext.reset()
            log.info("Removing all managed objects from bg context:", context: backgroundContext.registeredObjects.count)
        }
    }
    
    func save(with context: NSManagedObjectContext) {
        saveContext(context: context)
    }
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PanicMechanic")
        // Load db if it exists, or create it otherwise
        container.loadPersistentStores { storeDescription, error in
            
            // For merging duplicates, not sure if we need yet
            //            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                log.error("Unresolved error:", context: error)
                print("Unresolved error: \(error)")
            }
        }
        return container
    }()
    
    private func saveContext(context: NSManagedObjectContext) {
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    log.error("An error occurred while saving:", context: error)
                    print("An error occurred while saving: \(error)")
                }
            } else {
                log.warning("No changes detected, saving avoided.")
            }
        }
    }
    
    func fetchCycle(context: NSManagedObjectContext, handler: @escaping (Cycle?, Error?) -> Void) {
        context.performAndWait {
            let request = Cycle.createFetchRequest()
            let sort = NSSortDescriptor(key: "lastUpdated", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchLimit = 1
            var cycles: [Cycle]
            do {
                cycles = try context.fetch(request)
                log.verbose("Got most recent cycle:", context: cycles.count)
                handler(cycles.first, nil)
            } catch {
                log.error("Fetch failed:", context: error)
                handler(nil, error)
            }
        }
    }
    
    func fetchCycles(context: NSManagedObjectContext, start: Date, stop: Date?, handler: @escaping ([Cycle]?, Error?) -> Void) {
        context.performAndWait {
            let request = Cycle.createFetchRequest()
            let sort = NSSortDescriptor(key: "endTs", ascending: true)
            request.sortDescriptors = [sort]
            if let stop = stop {
                request.predicate = NSPredicate(format: "(endTs >= %@) AND (endTs <= %@)", start as NSDate, stop as NSDate)
            } else {
                request.predicate = NSPredicate(format: "(endTs >= %@)", start as NSDate)
            }
            var cycles: [Cycle]
            do {
                cycles = try context.fetch(request)
                log.verbose("Retrieved cycles:", context: cycles.count)
                handler(cycles, nil)
            } catch {
                log.error("Fetch failed:", context: error)
                handler(nil, error)
            }
        }
    }
    
    func fetchCycles(context: NSManagedObjectContext, handler: @escaping ([Cycle]?, Error?) -> Void) {
        context.performAndWait {
            let request = Cycle.createFetchRequest()
            let sort = NSSortDescriptor(key: "endTs", ascending: true)
            request.sortDescriptors = [sort]
            var cycles: [Cycle]
            do {
                cycles = try context.fetch(request)
                log.verbose("Retrieved cycles:", context: cycles.count)
                handler(cycles, nil)
            } catch {
                log.error("Fetch failed:", context: error)
                handler(nil, error)
            }
        }
    }
    
    func deleteCycles(context: NSManagedObjectContext, handler: @escaping (Error?) -> Void) {
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cycle")
            let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(delete)
                log.verbose("Delete successful")
            } catch let error as NSError {
                log.error("Error occured while deleting:", context: error)
            }
        }
    }
    
    func fetchHeadlessUser(context: NSManagedObjectContext, uid: String, handler: @escaping (HeadlessUser?, Error?) -> Void) {
        context.performAndWait {
            let request = HeadlessUser.createFetchRequest()
            request.predicate = NSPredicate(format: "uid == %@", uid)
            var users: [HeadlessUser]
            do {
                users = try context.fetch(request)
                log.verbose("Retrieved headless user:", context: users.count)
                handler(users.first, nil)
            } catch {
                log.error("Fetch failed:", context: error)
                handler(nil, error)
            }
        }
    }
    
    // MARK: - EpisodeLocation
    func fetchEpisodeLocation(context: NSManagedObjectContext, handler: @escaping (EpisodeLocation?, Error?) -> Void) {
        context.performAndWait {
            let request = EpisodeLocation.createFetchRequest()
            let sort = NSSortDescriptor(key: "lastUpdated", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchLimit = 1
            var locations: [EpisodeLocation]
            do {
                locations = try context.fetch(request)
                log.verbose("Got most recent location:", context: locations.count)
                handler(locations.first, nil)
            } catch {
                log.error("Fetch failed:", context: error)
                handler(nil, error)
            }
        }
    }
    
    func deleteEpisodeLocations(context: NSManagedObjectContext, handler: @escaping (Error?) -> Void) {
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EpisodeLocation")
            let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(delete)
                log.verbose("Delete successful")
            } catch let error as NSError {
                log.error("Error occured while deleting:", context: error)
            }
        }
    }
    
    // MARK: - HeadlessUser
    func fetchHeadlessUser(context: NSManagedObjectContext, handler: @escaping (HeadlessUser?, Error?) -> Void) {
        context.performAndWait {
            let request = HeadlessUser.createFetchRequest()
            let sort = NSSortDescriptor(key: "lastUpdated", ascending: false)
            request.sortDescriptors = [sort]
            request.fetchLimit = 1
            var users: [HeadlessUser]
            do {
                users = try context.fetch(request)
                log.verbose("Got most recent headless user:", context: users.count)
                handler(users.first, nil)
            } catch {
                log.error("Fetch failed:", context: error)
                handler(nil, error)
            }
        }
    }
    
    func deleteHeadlessUsers(context: NSManagedObjectContext, handler: @escaping (Error?) -> Void) {
        context.performAndWait {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HeadlessUser")
            let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try context.execute(delete)
                log.verbose("Delete successful")
            } catch let error as NSError {
                log.error("Error occured while deleting:", context: error)
            }
        }
    }
    
}


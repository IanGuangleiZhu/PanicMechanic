//
//  PropertyListClient.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import CoreData

protocol LocalStore {
    var viewContext: NSManagedObjectContext { get }
    var backgroundContext: NSManagedObjectContext { get }
    func clear()
    func save(with context: NSManagedObjectContext)
    func fetchCycles(context: NSManagedObjectContext, start: Date, stop: Date?, handler: @escaping ([Cycle]?, Error?) -> Void)
    func fetchCycle(context: NSManagedObjectContext, handler: @escaping (Cycle?, Error?) -> Void)
    func fetchCycles(context: NSManagedObjectContext, handler: @escaping ([Cycle]?, Error?) -> Void)
    func deleteCycles(context: NSManagedObjectContext, handler: @escaping (Error?) -> Void)
    func fetchHeadlessUser(context: NSManagedObjectContext, uid: String, handler: @escaping (HeadlessUser?, Error?) -> Void)
    
    func deleteEpisodeLocations(context: NSManagedObjectContext, handler: @escaping (Error?) -> Void)
    func fetchEpisodeLocation(context: NSManagedObjectContext, handler: @escaping (EpisodeLocation?, Error?) -> Void)
    
    func deleteHeadlessUsers(context: NSManagedObjectContext, handler: @escaping (Error?) -> Void)
    func fetchHeadlessUser(context: NSManagedObjectContext, handler: @escaping (HeadlessUser?, Error?) -> Void)
}

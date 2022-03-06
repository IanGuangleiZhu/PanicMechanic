//
//  User+CoreDataProperties.swift
//  wepanic-ios
//
//  Created by Synbrix Software on 1/22/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var gender: String?
    @NSManaged public var triggers: NSObject?
    @NSManaged public var nickname: String?
    @NSManaged public var episodes: NSSet?
    @NSManaged public var stats: Stats?

}

// MARK: Generated accessors for episodes
extension User {

    @objc(addEpisodesObject:)
    @NSManaged public func addToEpisodes(_ value: Episode)

    @objc(removeEpisodesObject:)
    @NSManaged public func removeFromEpisodes(_ value: Episode)

    @objc(addEpisodes:)
    @NSManaged public func addToEpisodes(_ values: NSSet)

    @objc(removeEpisodes:)
    @NSManaged public func removeFromEpisodes(_ values: NSSet)

}

//
//  EpisodeLocation+CoreDataProperties.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/31/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//
//

import Foundation
import CoreData


extension EpisodeLocation {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<EpisodeLocation> {
        return NSFetchRequest<EpisodeLocation>(entityName: "EpisodeLocation")
    }

    @NSManaged public var name: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var lastUpdated: Date?

}

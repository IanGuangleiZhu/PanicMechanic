//
//  HeartRateSample+CoreDataProperties.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//
//

import Foundation
import CoreData


extension HeartRateSample {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<HeartRateSample> {
        return NSFetchRequest<HeartRateSample>(entityName: "HeartRateSample")
    }

    @NSManaged public var bpm: Int16
    @NSManaged public var ts: Date?
    @NSManaged public var cycle: Cycle?

}

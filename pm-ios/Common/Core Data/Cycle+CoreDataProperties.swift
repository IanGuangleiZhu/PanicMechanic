//
//  Cycle+CoreDataProperties.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//
//

import Foundation
import CoreData


extension Cycle {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Cycle> {
        return NSFetchRequest<Cycle>(entityName: "Cycle")
    }

    @NSManaged public var endTs: Date?
    @NSManaged public var lastUpdated: Date?
    @NSManaged public var anxiety: AnxietyRating?
    @NSManaged public var hr: HeartRateSample?
    @NSManaged public var quality: QualityQuestion?
    @NSManaged public var trigger: TriggerQuestion?

}

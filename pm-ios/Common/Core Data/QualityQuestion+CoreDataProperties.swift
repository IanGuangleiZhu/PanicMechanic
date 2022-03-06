//
//  QualityQuestion+CoreDataProperties.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//
//

import Foundation
import CoreData


extension QualityQuestion {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<QualityQuestion> {
        return NSFetchRequest<QualityQuestion>(entityName: "QualityQuestion")
    }

    @NSManaged public var score: Int16
    @NSManaged public var ts: Date?
    @NSManaged public var type: String?
    @NSManaged public var cycle: Cycle?

}

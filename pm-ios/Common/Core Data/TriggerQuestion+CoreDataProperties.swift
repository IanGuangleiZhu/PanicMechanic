//
//  TriggerQuestion+CoreDataProperties.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/23/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//
//

import Foundation
import CoreData


extension TriggerQuestion {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<TriggerQuestion> {
        return NSFetchRequest<TriggerQuestion>(entityName: "TriggerQuestion")
    }

    @NSManaged public var trigger: String?
    @NSManaged public var ts: Date?
    @NSManaged public var cycle: Cycle?

}

//
//  HeadlessUser+CoreDataProperties.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/31/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//
//

import Foundation
import CoreData


extension HeadlessUser {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<HeadlessUser> {
        return NSFetchRequest<HeadlessUser>(entityName: "HeadlessUser")
    }

    @NSManaged public var age: Int16
    @NSManaged public var gender: String?
    @NSManaged public var nickname: String?
    @NSManaged public var lastUpdated: Date?

}

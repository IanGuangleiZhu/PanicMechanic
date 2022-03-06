//
//  Date+Operations.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/17/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

extension Date {
    
    static let birthdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "h:mm:ss a"
        return formatter
    }()
    
    /**
     Get current zeroed-out date in the user's current calendar.
     */
    static func current() -> Date {
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let year = calendar.component(.year, from: date)
        let components = DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
        return calendar.date(from: components)!
    }
    
    /**
     Adjust a date for daylight savings.
     - Parameter date: The date to be adjusted.
     - Parameter forward: Flag to adjust forward or not.
     
     - Returns: The optional adjusted date.
     */
    static func adjust(date: Date, forward: Bool) -> Date? {
        let tz = TimeZone.current
        let value = tz.isDaylightSavingTime(for: date) ? (forward ? 4 : -4) : (forward ? 5 : -5)
        return Calendar.current.date(byAdding: .hour, value: value, to: date)
    }
    
    /**
     - Parameter birthday: Date to calculate age from
     
     - Returns: Integer age in years
     */
    static func age(birthday: Date) -> Int {
        let seconds2years = 31536000.0
        return Int((Date() - birthday)/seconds2years)
    }
    
    /**
     - Parameter lhs: Subtractee
     - Parameter rhs: Subtractor
     
     - Returns: TimeInterval seconds between the two dates
     */
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    static func create(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
        return calendar.date(from: components)
    }
    
}

//
//  HistoryHeader.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/28/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct HistoryHeader {
    
    private let trigger: String
    private let timestamp: Date
    private let location: String
    
    private let timestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "d MMM yyyy"
        return formatter
    }()
    
    init(trigger: String, timestamp: Date, location: String) {
        self.trigger = trigger
        self.timestamp = timestamp
        self.location = location
    }
    
}

extension HistoryHeader : HistoryHeaderViewModel {

    var triggerString: String {
        return trigger
    }
    
    var whenWhereString: String {
        let formatted = timestampFormatter.string(from: timestamp)
        return String(format: "%@ / %@", formatted, location)
    }
    
}

extension HistoryHeader : TableViewItemViewModel {
    
    var height: Double {
        return HistoryHeaderView.standardHeight
    }
    var reuseIdentifier: String {
        return HistoryHeaderView.reuseIdentifier
    }
    
    var action: (() -> Void)? {
        return nil
    }
    
}

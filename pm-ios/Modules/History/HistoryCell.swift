//
//  HistoryCell.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/28/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

struct HistoryCell {
    
    let title: String
    let points: [(Int, Int)]
    let xMin: Double
    let xMax: Double
    let yMin: Double
    let yMax: Double
    
    init(title: String, points: [(Int, Int)], xMin: Double, xMax: Double, yMin: Double, yMax: Double) {
        self.title = title
        self.points = points
        self.xMin = xMin
        self.xMax = xMax
        self.yMin = yMin
        self.yMax = yMax
    }
    
}

extension HistoryCell : HistoryTableViewCellViewModel {
    
    var infoMessage: String {
        return title
    }
    
    var HistoryPoints: [(Int, Int)] {
        return points
    }
    
    var xRange: (Double, Double) {
        return (xMin, xMax)
    }
    
    var yRange: (Double, Double) {
        return (yMin, yMax)
    }
}

// MARK: - TableViewItem
extension HistoryCell : TableViewItemViewModel {
    
    var height: Double {
        return HistoryTableViewCell.standardHeight
    }
    var reuseIdentifier: String {
        return HistoryTableViewCell.reuseIdentifier
    }
    var action: (() -> Void)? { return nil }
    
}

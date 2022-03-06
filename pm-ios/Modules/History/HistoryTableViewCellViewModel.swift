//
//  HistoryTableViewCellViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/28/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol HistoryTableViewCellViewModel {
    var infoMessage: String { get }
    var HistoryPoints: [(Int, Int)] { get }
    var xRange: (Double, Double) { get }
    var yRange: (Double, Double) { get }
}

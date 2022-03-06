//
//  HeartRateService.swift
//  pm-ios
//
//  Created by Synbrix Software on 11/21/19.
//  Copyright © 2019 Synbrix Software. All rights reserved.
//

import Foundation

protocol HeartRateService {
    func calculate(samples: inout [Double]) -> Double?
}

class HeartRateAPIService {}

// MARK: - API
extension HeartRateAPIService: HeartRateService {
    
    func calculate(samples: inout [Double]) -> Double? {
        log.verbose("Calculating heart rate")
        let fs: Double = 30
        var hr: Double = 0
        var qual: Double = 0
        var size: Int32 = 240
        get_hr(&samples, &size, fs, &hr, &qual)
//        return qual == 1 ? hr : nil
        return hr > 0 ? hr : nil
    }
    
}

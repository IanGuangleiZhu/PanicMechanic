//
//  CollectionExtensions.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/31/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

// SOURCE: https://stackoverflow.com/questions/27259332/get-random-elements-from-array-in-swift/50853765
extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

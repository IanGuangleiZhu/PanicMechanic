//
//  EpisodeLocationService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/31/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol EpisodeLocationService {
    func loadLatestEpisodeLocation(handler: @escaping (EpisodeLocation?, Error?) -> Void)
    func create(name: String, latitude: Double, longitude: Double)
    func deleteEpisodeLocations(handler: @escaping (Error?) -> Void)
}

class EpisodeLocationAPIService {
    
    let localStore: LocalStore
    
    init(localStore: LocalStore) {
        self.localStore = localStore
    }
    
}

// MARK: - API
extension EpisodeLocationAPIService: EpisodeLocationService {
    
    // Fetching
    func loadLatestEpisodeLocation(handler: @escaping (EpisodeLocation?, Error?) -> Void) {
        localStore.fetchEpisodeLocation(context: localStore.backgroundContext, handler: handler)
    }
    
    // Saving
    func create(name: String, latitude: Double, longitude: Double) {
        let location = EpisodeLocation(context: localStore.backgroundContext)
        location.name = name
        location.latitude = latitude
        location.longitude = longitude
        location.lastUpdated = Date()
        localStore.save(with: localStore.backgroundContext)
    }
    
    // Delete
    func deleteEpisodeLocations(handler: @escaping (Error?) -> Void) {
        localStore.deleteEpisodeLocations(context: self.localStore.backgroundContext, handler: handler)
    }
    
}

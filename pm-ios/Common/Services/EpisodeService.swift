//
//  EpisodeService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol EpisodeService {
    func generateEpisodeId() -> String?
    func loadEpisodes(handler: @escaping ([PanicMechanicEpisode]?, Error?) -> Void)
    func addEpisode(episode: PanicMechanicEpisode, handler: @escaping (Error?) -> Void)
    func deleteEpisode(episode: PanicMechanicEpisode, handler: @escaping (Error?) -> Void)
}

class EpisodeAPIService {

    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

}

// MARK: - API
extension EpisodeAPIService: EpisodeService {
    
    func generateEpisodeId() -> String? {
        return apiClient.generateEpisodeId()
    }
    
    func loadEpisodes(handler: @escaping ([PanicMechanicEpisode]?, Error?) -> Void) {
        apiClient.getUser { user in
            if let user = user {
                self.apiClient.loadEpisodes(user: user, handler: handler)
            } else {
                log.error("Failed to load authenticated user.")
            }
        }
    }
    
    func addEpisode(episode: PanicMechanicEpisode, handler: @escaping (Error?) -> Void) {
        apiClient.getUser { user in
            if let user = user {
                self.apiClient.addEpisode(user: user, episode: episode, handler: handler)
            } else {
                log.error("Failed to load authenticated user.")
            }
        }
    }
    
    func deleteEpisode(episode: PanicMechanicEpisode, handler: @escaping (Error?) -> Void) {
        apiClient.getUser { user in
            if let user = user {
                self.apiClient.delete(user: user, episode: episode, handler: handler)
            } else {
                log.error("Failed to load authenticated user.")
            }
        }
    }

}

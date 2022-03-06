//
//  APIClient.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation

protocol APIClient {
    func configure(env: String)
    func disableNetwork(handler: @escaping (Error?) -> Void)
    func enableNetwork(handler: @escaping (Error?) -> Void)
    func getUser(handler: @escaping (AuthenticatedUser?) -> Void)
    func signIn(email: String, password: String, handler: @escaping (AuthenticatedUser?, Error?) -> Void)
    func signOut(handler: @escaping (Error?) -> Void)
    func register(email: String, password: String, handler: @escaping (Error?) -> Void)
    func sendPasswordReset(email: String, handler: @escaping (Error?) -> Void)
    func sendVerificationEmail(handler: @escaping (Error?) -> Void)
    func applyVerificationCode(code: String, handler: @escaping (Error?) -> Void)
    func reauthenticateUser(email: String, password: String, handler: @escaping (AuthenticatedUser?, Error?) -> Void)
    func reloadUser(handler: @escaping (Error?) -> Void)
    
    // User
    func addUser(user: PanicMechanicUser, handler: @escaping (Error?) -> Void)
    func addUser(uid: String, age: Int, gender: String, nickname: String?, handler: @escaping (Error?) -> Void)
    func updateNickname(uid: String, nickname: String, handler: @escaping (Error?) -> Void)
    func updateTriggers(uid: String, triggers: [String], handler: @escaping (Error?) -> Void)
    func deleteUser(uid: String, handler: @escaping (Error?) -> Void)
    func loadUser(uid: String, handler: @escaping (PanicMechanicUser?, Error?) -> Void)
    
    // Episode
    func generateEpisodeId() -> String?
    func loadEpisodes(user: AuthenticatedUser, handler: @escaping ([PanicMechanicEpisode]?, Error?) -> Void)
    func addEpisode(user: AuthenticatedUser, episode: PanicMechanicEpisode, handler: @escaping (Error?) -> Void)
    func addEpisode(user: AuthenticatedUser, start: Date, stop: Date, cycles: [Cycle], latitude: Double?, longitude: Double?, lname: String?, handler: @escaping (Error?) -> Void)
    func delete(user: AuthenticatedUser, episode: PanicMechanicEpisode, handler: @escaping (Error?) -> Void)
}

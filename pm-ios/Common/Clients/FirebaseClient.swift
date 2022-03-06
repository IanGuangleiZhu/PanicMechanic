//
//  FirebaseClient.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase
import SwiftyJSON

// NOTE: We need these extensions in order for these classes to conform to Codable
extension DocumentReference: DocumentReferenceType {}
extension GeoPoint: GeoPointType {}
extension FieldValue: FieldValueType {}
extension Timestamp: TimestampType {}

class FirebaseClient: APIClient {
    
    private let env = Environment().configuration(.env)
    private let userCollection = Environment().configuration(.userCollection)
    private let episodeCollection = Environment().configuration(.episodeCollection)

    private var authHandle: AuthStateDidChangeListenerHandle?
    private var userHandles: [ListenerRegistration] = []
    private var episodeHandles: [ListenerRegistration] = []
    
    deinit {
        teardown()
    }
    
    func configure(env: String) {
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        FirebaseApp.configure()
        DynamicLinks.performDiagnostics(completion: nil)
    }
    
    func teardown() {
        // Remove handlers
        if let authHandle = authHandle {
            Auth.auth().removeStateDidChangeListener(authHandle)
        }
        userHandles.forEach { handle in
            handle.remove()
        }
        episodeHandles.forEach { handle in
            handle.remove()
        }
        authHandle = nil
        userHandles.removeAll()
        episodeHandles.removeAll()
    }
    
    func disableNetwork(handler: @escaping (Error?) -> Void) {
        Firestore.firestore().disableNetwork(completion: handler)
    }
    
    func enableNetwork(handler: @escaping (Error?) -> Void) {
        Firestore.firestore().enableNetwork(completion: handler)
    }
        
    // MARK: - Auth -
    func getUser(handler: @escaping (AuthenticatedUser?) -> Void) {
        getUser { (user: User?) in
            if let user = user, let email = user.email {
                let pmu = AuthenticatedUser(uid: user.uid, email: email, verified: user.isEmailVerified)
                handler(pmu)
            } else {
                handler(nil)
            }
        }
    }
    
    private func getUser(handler: @escaping (User?) -> Void) {
        if let _ = authHandle {
            let user = Auth.auth().currentUser
            #if DEBUG
                log.info("Loaded user from current user:", context: [user])
            #endif
            handler(user)
        } else {
            authHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
                #if DEBUG
                    log.info("Loaded user from handle:", context: [user])
                #endif
                handler(user)
            }
        }
    }
    
    func signIn(email: String, password: String, handler: @escaping (AuthenticatedUser?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let user = user?.user, let email = user.email {
                let au = AuthenticatedUser(uid: user.uid, email: email, verified: user.isEmailVerified)
                handler(au, error)
            } else {
                handler(nil, error)
            }
        }
    }
    
    func signOut(handler: @escaping (Error?) -> Void) {
        userHandles.forEach { h in
            h.remove()
        }
        episodeHandles.forEach { h in
            h.remove()
        }
        userHandles.removeAll()
        episodeHandles.removeAll()
        do {
            try Auth.auth().signOut()
            handler(nil)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            handler(error)
        }
    }
    
    func sendPasswordReset(email: String, handler: @escaping (Error?) -> Void) {
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = false
        actionCodeSettings.url = URL(string: Environment().configuration(.url))
        actionCodeSettings.setIOSBundleID(Environment().configuration(.bundleID))
        actionCodeSettings.dynamicLinkDomain = Environment().configuration(.link)
        Auth.auth().sendPasswordReset(withEmail: email, actionCodeSettings: actionCodeSettings) { error in
            handler(error)
        }
    }
    
    func sendVerificationEmail(handler: @escaping (Error?) -> Void) {
        let actionCodeSettings =  ActionCodeSettings.init()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: Environment().configuration(.url))
        actionCodeSettings.setIOSBundleID(Environment().configuration(.bundleID))
        actionCodeSettings.dynamicLinkDomain = Environment().configuration(.link)
        Auth.auth().currentUser?.sendEmailVerification(with: actionCodeSettings) { error in
            handler(error)
        }
    }
    
    func applyVerificationCode(code: String, handler: @escaping (Error?) -> Void) {
        Auth.auth().checkActionCode(code) { _, error in
            if let error = error {
                handler(error)
            } else {
                Auth.auth().applyActionCode(code) { error in
                    handler(error)
                }
            }
        }
    }
    
    func reloadUser(handler: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.reload { error in
            handler(error)
        }
    }
    
    // MARK: - Register -
    func register(email: String, password: String, handler: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { user, error in
            handler(error)
        }
    }
    
    // MARK: - User -
    func addUser(user: PanicMechanicUser, handler: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let fbUser = FBUser(model: user)
        do {
            let data = try FirestoreEncoder().encode(fbUser)
            db.collection(userCollection).document(user.uid).setData(data) { error in
                handler(error)
            }
        } catch {
            log.error("Error decoding document.", context: error)
            handler(error)
        }
    }
    
    func addUser(uid: String, age: Int, gender: String, nickname: String?, handler: @escaping (Error?) -> Void) {
        var data: [String: Any] = [
            "age": age,
            "gender": gender,
            "stats": [
                "recovery_duration": 0,
                "total_attack": 0
            ],
            "triggers": []
        ]
        if let nickname = nickname {
            data["nickname"] = nickname
        }
        Firestore.firestore().collection(userCollection).document(uid).setData(data) { error in
            handler(error)
        }
    }
    
    func updateNickname(uid: String, nickname: String, handler: @escaping (Error?) -> Void) {
        let data = ["nickname": nickname]
        
        let db = Firestore.firestore()
        let userRef = db.collection(userCollection).document(uid)
        userRef.updateData(data) { error in
            handler(error)
        }
    }
    
    func updateTriggers(uid: String, triggers: [String], handler: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let data = ["triggers": triggers]
        let userRef = db.collection(userCollection).document(uid)
        userRef.updateData(data) { error in
            handler(error)
        }
    }
    
    func deleteUser(uid: String, handler: @escaping (Error?) -> Void) {
        Auth.auth().currentUser?.delete { error in
            handler(error)
        }
    }
    
    func reauthenticateUser(email: String, password: String, handler: @escaping (AuthenticatedUser?, Error?) -> Void) {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        Auth.auth().currentUser?.reauthenticate(with: credential) { user, error in
            if let user = user?.user, let email = user.email {
                let au = AuthenticatedUser(uid: user.uid, email: email, verified: user.isEmailVerified)
                handler(au, error)
            } else {
                handler(nil, error)
            }
        }
    }
    
    func loadUser(uid: String, handler: @escaping (PanicMechanicUser?, Error?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection(userCollection).document(uid)
        let handle = userRef.addSnapshotListener { snapshot, error in
            guard let document = snapshot, document.exists, let data = document.data() else {
                log.error("Error fetching document:", context: error)
                handler(nil, error)
                return
            }
            do {
                let fbuser = try FirestoreDecoder().decode(FBUser.self, from: data)
                let user = PanicMechanicUser(model: fbuser)
                handler(user, nil)
            } catch {
                log.error("Error decoding document.", context: error)
                handler(nil, error)
            }
            
        }
        userHandles.append(handle)
        log.info("Active user handles:", context: userHandles.count)
    }
    
    // MARK: - Episode -
    func generateEpisodeId() -> String? {
        let episodeDoc = Firestore.firestore().collection(episodeCollection).document()
        return episodeDoc.documentID
    }
    
    func loadEpisodes(user: AuthenticatedUser, handler: @escaping ([PanicMechanicEpisode]?, Error?) -> Void) {
        let db = Firestore.firestore()
        let episodesRef = db.collection(episodeCollection).order(by: "start_ts", descending: true)
        let userRef = db.collection(userCollection).document(user.uid)
        
        let query = episodesRef.whereField("user_ref", isEqualTo: userRef)
        log.info("[\(env)] Loading episodes...\(userCollection), \(episodeCollection)", context: [userRef, episodesRef])
        
        let handle = query.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                log.error("Error fetching documents:", context: error)
                handler(nil, error)
                return
            }
            log.info("Episode documents retrieved.", context: documents.count)
            var eps: [PanicMechanicEpisode] = []
            for document in documents {
                let data = document.data()
                do {
                    let fbepisode = try FirestoreDecoder().decode(FBEpisode.self, from: data)
                    let ep = PanicMechanicEpisode(model: fbepisode)
                    eps.append(ep)
                } catch {
                    log.error("Error decoding document.", context: error)
                    handler(nil, error)
                    return
                }
            }
            handler(eps, nil)
        }
        episodeHandles.append(handle)
        log.info("Active episode handles:", context: episodeHandles.count)
    }
    
    func addEpisode(user: AuthenticatedUser, episode: PanicMechanicEpisode, handler: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection(userCollection).document(user.uid)
        
        // Encode the episode
        let fbEpisode = FBEpisode(model: episode)
        do {
            var data = try FirestoreEncoder().encode(fbEpisode)
            data["user_ref"] = userRef // Set the user reference value manually because we don't store it with the model
            db.collection(episodeCollection).document(episode.uid).setData(data) { error in
                handler(error)
            }
        } catch {
            log.error("Error decoding document.", context: error)
            handler(error)
        }
    }
    
    func addEpisode(user: AuthenticatedUser, start: Date, stop: Date, cycles: [Cycle], latitude: Double?, longitude: Double?, lname: String?, handler: @escaping (Error?) -> Void) {
        getUser { (user: AuthenticatedUser?) in
            if let user = user {
                let db = Firestore.firestore()
                let userRef = db.collection(self.userCollection).document(user.uid)
                var document: [String: Any] = ["start_ts": start, "stop_ts": stop, "user_ref": userRef]
                if let latitude = latitude, let longitude = longitude, let lname = lname {
                    let geoPoint = GeoPoint(latitude: latitude, longitude: longitude)
                    document["location"] = ["coordinate": geoPoint, "name": lname]
                }
                let cycleData: [[String: Any]] = cycles.map { cycle in
                    var data: [String: Any] = [:]
                    if let hr = cycle.hr, let ts = hr.ts {
                        let hrSample: [String: Any] = ["bpm": hr.bpm, "ts": ts]
                        data["hr"] = hrSample
                    }
                    if let anxiety = cycle.anxiety, let ts = anxiety.ts {
                        let anxietySample: [String: Any] = ["rating": anxiety.score, "ts": ts]
                        data["anxiety"] = anxietySample
                    }
                    if let triggerQuestion = cycle.trigger, let trigger = triggerQuestion.trigger {
                        data["question"] = ["TRIGGER": trigger]
                    }
                    if let qualityQuestion = cycle.quality, let type = qualityQuestion.type {
                        data["question"] = [type: qualityQuestion.score]
                    }
                    data["end_ts"] = cycle.endTs
                    return data
                }
                document["cycles"] = cycleData
                db.collection("episode").document().setData(document) { error in
                    handler(error)
                }
            }
        }
    }
    
    func delete(user: AuthenticatedUser, episode: PanicMechanicEpisode, handler: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection(episodeCollection).document(episode.uid).delete() { error in
            handler(error)
        }
        
    }
    
}

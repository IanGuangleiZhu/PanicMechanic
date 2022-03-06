//
//  HomeViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import CoreLocation

class HomeViewModel: NSObject {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    weak var viewDelegate: HomeViewModelViewDelegate?
    
    // MARK: - Dependencies
    private let user: AuthenticatedUser?
    var localCache: LocalCache
    let userService: UserService
    let cycleService: CycleService?
    let episodeLocationService: EpisodeLocationService?
    let headlessUserService: HeadlessUserService?
    let isTutorial: Bool
    
    // MARK: - Properties
    private var pmUser: PanicMechanicUser? {
        didSet {
            if let _ = pmUser {
                viewDelegate?.enablePanicButton()
            } else {
                viewDelegate?.disablePanicButton()
            }
        }
    }
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    // MARK: - Lifecycle
    init(user: AuthenticatedUser?, localCache: LocalCache, userService: UserService, cycleService: CycleService?, episodeLocationService: EpisodeLocationService?, headlessUserService: HeadlessUserService?, isTutorial: Bool) {
        self.user = user
        self.localCache = localCache
        self.userService = userService
        self.cycleService = cycleService
        self.episodeLocationService = episodeLocationService
        self.headlessUserService = headlessUserService
        self.isTutorial = isTutorial
    }
    
}

// MARK: - Model Type
extension HomeViewModel: HomeViewModelType {
    
    var shouldShowNextButton: Bool {
        return isTutorial
    }
    
    func start() {
        if !isTutorial {
            episodeLocationService?.deleteEpisodeLocations { error in
                if let error = error {
                    log.error("error deleting locations:", context: error)
                    return
                }
                log.info("Successfully deleted cached locations.")
            }
        }
        
        // Debug Only
        loadCycles()
        
        // Load User
        if !isTutorial {
            performSelector(inBackground: #selector(loadUser), with: nil)
        }
        
        if isTutorial {
            viewDelegate?.enablePanicButton()
        }
    }
    
    func panic() {
        if !isTutorial {
            locationManager.requestLocation()
            localCache.attackStartTimestamp = Date()
            localCache.currentCycleCount = 0
            coordinatorDelegate?.proceedFromHome(with: pmUser)
        } else {
            coordinatorDelegate?.proceedFromHome(with: nil)
        }
    }
    
    func startTutorial() {
        if isTutorial {
            viewDelegate?.showCoachMarks()
        }
    }
    
    func stopTutorial() {
        if isTutorial {
            viewDelegate?.hideCoachMarks()
        }
    }
    
    func togglePractice(isOn: Bool) {
        localCache.practiceModeEnabled = isOn
    }
    
}


extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            print("Location Authorized: \(status)")
        } else {
            print("Location Unuthorized: \(status)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation = locations.last!
        print("Received Location: \(lastLocation)")
        let geocoder = CLGeocoder()
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(lastLocation) { placemarks, error in
            if let error = error {
                print("Error getting location: \(error.localizedDescription)")
            } else {
                let firstLocation = placemarks?[0]
                if let locality = firstLocation?.locality, let city = firstLocation?.administrativeArea {
                    let name = "\(locality), \(city)"
                    self.episodeLocationService?.create(name: name, latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        // Notify the user of any errors.
        print(error.localizedDescription)
    }
    
}

// MARK: - Private Helpers
extension HomeViewModel {
    
    @objc private func loadUser() {
        userService.loadUser { pmUser, error in
            if let error = error {
                log.error("Error loading user document:", context: error)
                return
            } else {
                if let pmUser = pmUser {
                    log.info("Successfully loaded user document:", context: pmUser.uid)
                    self.pmUser = pmUser
                } else {
                    log.warning("No user document exists:")
                    self.addHeadlessUser()
                }
            }
        }
    }
    
    private func addHeadlessUser() {
        headlessUserService?.loadLatestHeadlessUser { headUser, error in
            if let error = error {
                #if DEBUG
                    log.error("error loading headless user:", context: error)
                #endif
                return
            }
            #if DEBUG
                log.info("Successfully loaded latest headless user.", context: [headUser])
            #endif
            if let headUser = headUser, let gender = headUser.gender {
                self.addUser(age: Int(headUser.age), gender: gender, nickname: headUser.nickname)
            }
        }
    }
    
    private func addUser(age: Int, gender: String, nickname: String?) {
        guard let userGender = UserGender(rawValue: gender) else { return }
        let stats = UserStats(recoveryDuration: 0, totalAttacks: 0)
        if let user = user {
            let pmu = PanicMechanicUser(uid: user.uid, age: age, gender: userGender, nickname: nickname, stats: stats, triggers: [])
             userService.addUser(user: pmu) { error in
                 if let error = error {
                     //                self.viewDelegate?.showError(message: error.localizedDescription)
                     log.error("Add user document failed:", context: error)
                     return
                 }
                 log.info("Successfully added new user document.")
                 self.headlessUserService?.deleteHeadlessUsers { error in
                     if let error = error {
                         //                        self.viewDelegate?.hideLoadingIndicator()
                         //                self.viewDelegate?.showError(message: error.localizedDescription)
                         log.error("Delete headless users failed:", context: error)
                         return
                     }
                     log.info("Successfully removed headless users.")
                 }
             }
        }
    }
    
    private func loadCycles() {
        cycleService?.loadCycles { cycles, error in
            if let error = error {
                #if DEBUG
                log.warning("ERROR FETCHING:", context: error)
                #endif
            } else {
                if let cycles = cycles {
                    #if DEBUG
                        log.info("FETCHED CYCLES:", context: cycles.count)
                        for (idx, cycle) in cycles.enumerated() {
                            
                                print("Cycle \(idx):")
                                print("\t\(cycle)")
                            
                        }
                    #endif
                    if cycles.count > 0 {
                        self.clearCycleCache()
                    }
                } else {
                    #if DEBUG
                        log.warning("NO FETCHED CYCLES")
                    #endif
                }
            }
        }
    }
    
    private func clearCycleCache() {
        cycleService?.deleteCycles { error in
            if let error = error {
                log.error("Error clearing cycle cache:", context: error)
                return
            }
            log.info("Cycle cache successfully cleared.")
        }
    }
    
}

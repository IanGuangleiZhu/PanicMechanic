//
//  TutorialRequirementsViewModel.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/19/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import AVFoundation
import CoreLocation

class TutorialRequirementsViewModel: NSObject, TutorialRequirementsViewModelType {
    
    // MARK: - Delegates -
    weak var coordinatorDelegate: TutorialRequirementsViewModelCoordinatorDelegate?
    weak var viewDelegate: TutorialRequirementsViewModelViewDelegate?
    
    // MARK: - Properties
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
}

// MARK: - Model Type -
extension TutorialRequirementsViewModel {
    
    func start() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            viewDelegate?.updateCameraSwitch(isOn: true)
        }
        let locationAuthorized = CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
        if CLLocationManager.locationServicesEnabled() && locationAuthorized {
            viewDelegate?.updateLocationSwitch(isOn: true)
        }
    }
    
    func proceed() {
        coordinatorDelegate?.proceedFromRequirements()
    }
    
    func requestCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    self.viewDelegate?.updateCameraSwitch(isOn: granted)
                }
            case .authorized:
                log.info("User has already authorized use of camera.")
            case .denied, .restricted:
                log.warning("User has restricted use of camera.")
            @unknown default:
                log.warning("Media capture authorization entered unknown state.")
        }
    }
    
    func requestLocationAccess() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            log.info("User has already authorized location services.")
        default:
            log.warning("User has restricted location services.")
        }
    }
}

extension TutorialRequirementsViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         if status == .authorizedWhenInUse || status == .authorizedAlways {
            viewDelegate?.updateLocationSwitch(isOn: true)
         } else {
            viewDelegate?.updateLocationSwitch(isOn: false)
         }
     }
    
}

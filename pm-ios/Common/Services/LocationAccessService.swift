//
//  LocationAccessService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import CoreLocation

protocol LocationClient {
    var requestHandler: ((Bool) -> Void)? { get set }
    var locationHandler: ((CLLocationCoordinate2D?, String?, Error?) -> Void)? { get set }
    func requestAccess()
    func getLocation()
}

class CoreLocationClient: NSObject, LocationClient {
    
    var requestHandler: ((Bool) -> Void)?
    var locationHandler: ((CLLocationCoordinate2D?, String?, Error?) -> Void)?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    init(requestHandler: ((Bool) -> Void)?, locationHandler: ((CLLocationCoordinate2D?, String?, Error?) -> Void)?) {
        self.requestHandler = requestHandler
        self.locationHandler = locationHandler
    }
    
    func requestAccess() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("User has already authorized location services.")
            requestHandler?(true)
        default:
            print("User has restricted location services.")
            requestHandler?(false)
        }
    }
    
    func getLocation() {
        locationManager.requestLocation()
    }
    
}

extension CoreLocationClient: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            requestHandler?(true)
        } else {
            requestHandler?(false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation = locations.last!

        print("Received Location: \(lastLocation)")
        
        let geocoder = CLGeocoder()
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(lastLocation) { placemarks, error in
            if let error = error {
                self.locationHandler?(lastLocation.coordinate, nil, error)
            } else {
                let firstLocation = placemarks?[0]
                if let locality = firstLocation?.locality, let country = firstLocation?.country {
                    let name = "\(locality), \(country)"
                    self.locationHandler?(lastLocation.coordinate, name, error)
                } else {
                    self.locationHandler?(lastLocation.coordinate, nil, nil)
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

protocol LocationAccessService {
    func requestAccess(completion: ((Bool) -> Void)?)
}

class LocationAccessAPIService {
    
    let locationClient: LocationClient

    init(locationClient: LocationClient) {
        self.locationClient = locationClient
    }
    
}

// MARK: - API
extension LocationAccessAPIService: LocationAccessService {
    
    func requestAccess(completion: ((Bool) -> Void)?) {

    }
    
}

protocol LocationServiceDelegate: class {
    func didReceiveLocation(name: String, latitude: Double, longitude: Double)
}


///***************************************
final class LocationService: NSObject {
    
    weak var delegate: LocationServiceDelegate?
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()
    
    override init() {
        super.init()
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("User has already authorized location services.")
        default:
            print("User has restricted location services.")
        }
        
    }

    func getLocation() {
        locationManager.requestLocation()
    }

}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!

        print("LAST LOCATION: \(lastLocation)")
        
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(lastLocation,
                    completionHandler: { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
//                completionHandler(firstLocation)
                if let locality = firstLocation?.locality, let country = firstLocation?.country {
                    self.delegate?.didReceiveLocation(name: "\(locality), \(country)", latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
                }
            }
            else {
             // An error occurred during geocoding.
//                completionHandler(nil)
//                print(error?.localizedDescription)
            }
        })
        
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

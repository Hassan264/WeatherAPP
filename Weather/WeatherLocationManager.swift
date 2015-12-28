//
//  WeatherLocationManager.swift
//  Weather
//
//  Created by Hassan Almasri on 26/12/2015.
//  Copyright © 2015 Hassan Almasri. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationUpdateObserver: class {
    func newLocationAvailable(location: CLLocation)
}

class WeatherLocationManager: NSObject {
    
    static let sharedInstance = WeatherLocationManager()
    
    private let locationManager: CLLocationManager!
    var currentUserLocation: CLLocation?
    
    private var subsribers: [LocationUpdateObserver] = []
    
    private override init() {
        
        self.locationManager = CLLocationManager()
        
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()

        self.startUpdatingLocation()
        
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func subscribeNewLocation(object: LocationUpdateObserver) {
        self.subsribers.append(object)
    }
    
    func unsubscribeNewLocation(object: LocationUpdateObserver) {
        self.subsribers.removeObject(object)
    }
    
}

// MARK: Delegate
extension WeatherLocationManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for sub in self.subsribers {
            sub.newLocationAvailable(locations.last!)
        }
    }
    
}
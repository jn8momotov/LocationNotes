//
//  LocationManager.swift
//  LocationNotes
//
//  Created by Евгений on 24/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit
import CoreLocation

struct LocationCoordinate {
    
    var latitude: Double
    var longitude: Double

    static func newLocation(location: CLLocation) -> LocationCoordinate {
        return LocationCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

class LocationManager: NSObject, CLLocationManagerDelegate {

    static let sharedInstance = LocationManager()
    
    var manager = CLLocationManager()
    
    func requestAuth() {
        manager.requestWhenInUseAuthorization()
    }
    
    var handlerForSave: ((LocationCoordinate) -> Void)?
    
    func getCurrentLocation(handler: ((LocationCoordinate) -> Void)?) {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            print("Нет доступа к локации")
            return
        }
        handlerForSave = handler
        manager.delegate = self
        manager.activityType = .other
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        print("Начали получать локацию")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locCoord = LocationCoordinate.newLocation(location: locations.last!)
        handlerForSave?(locCoord)
        manager.stopUpdatingLocation()
    }
}

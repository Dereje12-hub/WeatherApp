//
//  Location.swift
//  WeatherApp
//
//  Created by Dereje Gudeta on 5/21/23.
//
import CoreLocation
import UIKit
    
public class Location: NSObject, CLLocationManagerDelegate {
        let manager = CLLocationManager()
        var locationCallback: ((CLLocation?) -> Void)!
        var locationServicesEnabled = false
        var didFailWithError: Error?
        
        public func run(callback: @escaping (CLLocation?) -> Void) {
            locationCallback = callback
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            manager.requestWhenInUseAuthorization()
           
            
            /*
            isAuthorizedtoGetUserLocation()
            
            //if we have no permission to access user location, then ask user for permission.
            func isAuthorizedtoGetUserLocation() {
                if CLLocationManager.locationServicesEnabled() {
                    manager.requestWhenInUseAuthorization()
                    
                }
            }
            */
            /*
            DispatchQueue.global().async {
                  if CLLocationManager.locationServicesEnabled() {
                      self.locationServicesEnabled =  CLLocationManager.locationServicesEnabled()
                  }
            }
            */
            
            
            locationServicesEnabled = CLLocationManager.locationServicesEnabled()
            if locationServicesEnabled {
                manager.startUpdatingLocation()
            }
            else {
                locationCallback(nil)
            }
        }
        
        public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locationCallback(locations.last!)
            manager.stopUpdatingLocation()
            
        }
        public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            didFailWithError = error
            locationCallback(nil)
            manager.stopUpdatingLocation()
            
        }
        deinit {
            manager.stopUpdatingLocation()
            
        }
    
}

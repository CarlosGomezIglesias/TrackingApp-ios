//
//  LocationService.swift
//  TrackingApp
//
//  Created by Tardes on 10/6/26.
//

import CoreLocation
import FirebaseFirestore

final class LocationService: NSObject, CLLocationManagerDelegate{
    //patron singleton, se le puede llamar desde cualquier clase y devuelve siempre el mismo objeto
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    
    var routeId: String? = nil
    
    private(set) var isTracking = false
    
    override init() {
        super.init()
        //tu delegado es este objeto
        locationManager.delegate = self
        
        //que la precision sea de 10 metros (cuanta mas precision mas bateria gasta)
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //que funcione en segundo plano
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.pausesLocationUpdatesAutomatically = false
        
        //que coja coordenadas cada 10 metros
        locationManager.distanceFilter = 10
        //locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func startTracking(forRouteId routeId: String) {
        self.routeId = routeId
        //asegurame que no estoy trackeando ya
        guard !isTracking else { return }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        isTracking = true
    }
    
    func stopTracking() {
        //asegurame que esta trackeando ya
        guard isTracking else { return }
        
        locationManager.stopUpdatingLocation()
        isTracking = false
        self.routeId = nil
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
                return
            }

            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            print(latitude, longitude)

            if routeId != nil {
                Task {
                    do {
                        let db = Firestore.firestore()
                        
                        let coordinate = Coordinate(routeId: routeId!, latitude: latitude, longitude: longitude, timestamp: Date().millisecondsSince1970)
                        
                        try db.collection("Coordinates").addDocument(from: coordinate)
                    } catch {
                        print("Error creating document: \(error)")
                    }
                }
            }
        }
}

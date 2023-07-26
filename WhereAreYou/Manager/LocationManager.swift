//
//  LocationManager.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/02.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

final class LocationMagager:NSObject,ObservableObject,CLLocationManagerDelegate,MKMapViewDelegate{
    
    private var manager = CLLocationManager()
    var mySpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.3504119, longitude: 127.3845475), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @Published var isChanged = false

    override init() {
            super.init()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        }

    func cheackLocation(){
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.cheackLocationAuthrization()
            }else{
                print("지도가 꺼져있음")
            }
        }
    }
    

    func cheackLocationAuthrization(){
        switch manager.authorizationStatus{
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted:
            print("위치정보 제한")
        case .denied:
            print("위치정보 거부")
        case .authorizedAlways, .authorizedWhenInUse:
            withAnimation(.default){
                self.mapRegion = MKCoordinateRegion(center:self.manager.location!.coordinate, span: self.mySpan)
            }
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            locations.last.map {
                self.mapRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                    span: mySpan
                )
            }
        }
 
}

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
import Combine

final class LocationMagager:NSObject,ObservableObject,CLLocationManagerDelegate,MKMapViewDelegate{
    
    private var manager = CLLocationManager()
    var cancellable:AnyCancellable?
    
    var mySpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    @Published var mapRegion = MKCoordinateRegion()
//    MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.3504119, longitude: 127.3845475), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    @Published var isChanged = false
    @Published var searchText = ""
    @Published var mapView = MKMapView()
    @Published var fetchPlace:[CLPlacemark]?
    @Published var pickedPlaceMark:CLPlacemark?
    @Published var pickedLocation:CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != ""{
                    self.fetchPlaces(value: value)
                }else{
                    self.fetchPlace = nil
                }
            })
    }
    
    func fetchPlaces(value:String){
        Task{
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = value.lowercased()
            let response = try? await MKLocalSearch(request: request).start()
            await MainActor.run(body: {
                self.fetchPlace = response?.mapItems.compactMap({ item -> CLPlacemark? in
                    return item.placemark
                })
            })
        }
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
    func updatePlacemark(location:CLLocation){
        Task{
            guard let place = try? await reverseLocationCoordinate(location: location) else {return}
            await MainActor.run(body: {
                self.pickedPlaceMark = place
            })
        }
    }
    func reverseLocationCoordinate(location:CLLocation)async throws -> CLPlacemark?{
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
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
            self.mapRegion = MKCoordinateRegion(center:self.manager.location!.coordinate, span: self.mySpan)
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            self.mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: mySpan)
        }
    }
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        DispatchQueue.main.async {
            self.isChanged = true
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
        let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)

        self.convertLocationToAddress(location: location)
            DispatchQueue.main.async {
                self.isChanged = false
            }
        }
    func convertLocationToAddress(location: CLLocation) {
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "ko")

            geocoder.reverseGeocodeLocation(location,preferredLocale: locale) { placemarks, error in
                guard error == nil else{ return }

                guard let placemark = placemarks?.first else { return }
                self.pickedPlaceMark = placemark
            }
        }
    
}

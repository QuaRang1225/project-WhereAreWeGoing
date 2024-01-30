//
//  MapViewHelper.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/28.
//

import SwiftUI
import UIKit
import MapKit

struct MapViewHelper: UIViewRepresentable {
    
    
    
    
    @EnvironmentObject var location:LocationMagager
    
    func makeCoordinator() -> Coordinator {
        return MapViewHelper.Coordinator(parent: self)
    }
    func makeUIView(context: UIViewRepresentableContext<MapViewHelper>) -> MKMapView {
        
        location.mapView.setRegion(location.mapRegion, animated: true)
        location.mapView.delegate = context.coordinator
        return location.mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator:NSObject,MKMapViewDelegate{
        
        var parent:MapViewHelper
        
        init(parent: MapViewHelper) {
            self.parent = parent
            
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            DispatchQueue.main.async {
                self.parent.location.isChanged = true
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
            let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            
            self.convertLocationToAddress(location: location)
            DispatchQueue.main.async {
                self.parent.location.isChanged = false
            }
        }
        
        
        func convertLocationToAddress(location: CLLocation) {
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "ko")
            
            geocoder.reverseGeocodeLocation(location,preferredLocale: locale) { placemarks, error in
                guard error == nil else{ return }
                
                guard let placemark = placemarks?.first else { return }
                self.parent.location.pickedPlaceMark = placemark
            }
        }
    }
}

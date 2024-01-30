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
    
    var manager = CLLocationManager()
    
    var mySpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    var cancellable:AnyCancellable?
    @Published var mapRegion = MKCoordinateRegion()
    
    @Published var isChanged = false    //맵 움직임 감지 프로퍼티
    @Published var searchText = ""  //검색 텍스트
    @Published var mapView = MKMapView()
    @Published var fetchPlace:[CLPlacemark]?        //사용자에게 보여줄 실질적인 위치 검색 리스트
    @Published var pickedPlaceMark:CLPlacemark?     //주소
    @Published var pickedLocation:CLLocation?       //좌표
    @Published var mapCoordinate = CLLocationCoordinate2D()     //좌표(위도,경도)
    
    override init(){
        super.init()
        DispatchQueue.global(qos: .background).async {
            self.manager.delegate = self
            self.manager.desiredAccuracy = kCLLocationAccuracyBest   //정확도 최고로 설정
            self.manager.requestWhenInUseAuthorization() //앱 사용중과 관계 없이 위치서비스 사용자권한 요청
            self.manager.startUpdatingLocation()
        }
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
    
    //------------- 좌표 -> 주소 변환 -------------------------
    func fetchPlaces(value:String){ //들어온 값이 포함되어있는 주소들을 찾아서 비동기로 변수에 저장
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
    
    private func reverseLocationCoordinate(location:CLLocation)async throws -> CLPlacemark?{    //주소로 변한
        let place = try await CLGeocoder().reverseGeocodeLocation(location).first
        return place
    }
    
    func updatePlacemark(location:CLLocation){  //주소 변경 메서드
        Task{
            guard let place = try? await reverseLocationCoordinate(location: location) else {return}    //변환한 주소 비동기로 변수에 저장
            await MainActor.run(body: {
                self.pickedPlaceMark = place
            })
        }
    }
    
    
    //--------------- 맵뷰 메서드 -----------------------
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {  //맵 움직임 감지
        DispatchQueue.main.async {
            self.isChanged = true
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) { //맵 움직임 멈춤 감지
        let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        self.convertLocationToAddress(location: location)
        DispatchQueue.main.async {
            self.isChanged = false
        }
    }
    
    
    //--------------------- 변환 메서드 -----------------------
    func convertLocationToAddress(location: CLLocation) {   //좌표를 주소로 변경
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "ko")
        
        geocoder.reverseGeocodeLocation(location,preferredLocale: locale) { placemarks, error in
            guard error == nil else{ return }
            
            guard let placemark = placemarks?.first else { return }
            self.pickedPlaceMark = placemark
        }
    }
    
    
    //------------------- 네비게이션 버튼 및 본인 위치 호출 메서드 --------------------------------
    private func cheackLocationAuthrization(){
        switch self.manager.authorizationStatus{
        case .notDetermined:
            self.manager.requestAlwaysAuthorization()
        case .restricted:
            print("위치정보 제한")
        case .denied:
            print("위치정보 거부")
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.mapCoordinate = self.manager.location!.coordinate
            }
        @unknown default:
            break
        }
    }
    internal func locationManagerDidChangeAuthorization(_ manager: CLLocationManager){   //위치 서비스에 대한 권한 상태가 변경될 때 호출되는 델리게이트 메서드 (위치를 사용할때 호출 -- 로케이션 버튼)
        self.cheackLocationAuthrization()
    }
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {    //현제 위치 불러오는 메서드
        
        locations.last.map {
            self.mapRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude),
                span: mySpan)
            
        }
    }
}

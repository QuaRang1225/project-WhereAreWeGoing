//
//  TestView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/09.
//


//class AA:ObservableObject{
//    @Published var aa = false
//}
//struct TestView: View {
//    @StateObject var vm = AA()
//    var body: some View{
//        if vm.aa{
//            Text("asda")
//        }else{
//            AAA()
//                .environmentObject(vm)
//        }
//    }
//}
//struct AAA:View{
//
//    @State var a = false
//    @EnvironmentObject var vm:AA
//    var body: some View {
//        Button {
//            a =  true
//        } label: {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//        }
//        .sheet(isPresented: $a) {
//            BBB()
//                .environmentObject(vm)
//        }
//    }
//}
//struct BBB:View{
//
//    @EnvironmentObject var vm:AA
//    var body: some View {
//        Button {
//            vm.aa =  true
//        } label: {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//        }
//    }
//}
import Foundation
import SwiftUI
import UIKit
import MapKit
import CoreLocation
import Combine


struct TestView:View{

//    @State var title = ""
//    @State var subtitle = ""
//    @State var city = ""
//    @State var contry = ""
//    @State var isChanged = false
//
//
//    @State var fetchPlace:[CLPlacemark]?
//    @State var searchText = ""
//
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.298971, longitude: 127.354717), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
//
//    var body: some View{
//        ZStack(alignment: .bottom) {
//
//            MapView(contry:$contry,city: $city, title: $title, subtitle: $subtitle,isChanged: $isChanged, region: $region)
//                .overlay {
//                    Image("where")
//                        .resizable()
//                        .frame(width: 60,height: 80)
//                        .offset(y:isChanged ? -50 : -40)
//                        .background{
//                            Capsule()
//                                .frame(width: 20,height: 15)
//                                .foregroundColor(.gray.opacity(0.5))
//                        }
//                }
//            VStack{
//                HStack{
//                    CustomTextField(placeholder: "", isSecure: false, color: .red, text: $searchText)
//                    Button {
////                        fetchPlaces(value: "대전광역시 서구 가수원동 807-5")
//                        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                    } label: {
//                        Text("버튼")
//                    }
//
//                }
//
//                Text(contry)
//                    .bold()
//                    .font(.title3)
//                Text(city)
//            }
//        }
////        .onChange(of: fetchPlace) { newValue in
////            region.center = (newValue?.first?.location!.coordinate)!
////        }
//
//    }
//    func fetchPlaces(value:String){
//        Task{
//            let request = MKLocalSearch.Request()
//            request.naturalLanguageQuery = value.lowercased()
//            let response = try? await MKLocalSearch(request: request).start()
//            await MainActor.run(body: {
//                self.fetchPlace = response?.mapItems.compactMap({ item -> CLPlacemark? in
//                    return item.placemark
//                })
//            })
//        }
//    }
    @State private var selectedStartTime = Date()
        @State private var selectedEndTime = Date()
        
        var body: some View {
            VStack {
                Text("24-hour Analog Clock")
                    .font(.title)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 250, height: 250)
                    
                    ForEach(1...24, id: \.self) { hour in
                        let angle = Double(hour) * 360 / 24
                        HourMarker(angle: .degrees(angle),hour: hour)
                    }
                    
                    ClockHand(angle: angleForTime(selectedStartTime), color: .black)
                    ClockHand(angle: angleForTime(selectedEndTime), color: .black)
                    ClockArc(startAngle: angleForTime(selectedStartTime), endAngle: angleForTime(selectedEndTime))
                    Circle()
                        .foregroundColor(.black)
                        .frame(width: 10,height: 10)
                }
                .frame(width: 250, height: 250)
                
                Spacer()
                
                Text("Selected Start Time: \(formatTime(selectedStartTime))")
                Text("Selected End Time: \(formatTime(selectedEndTime))")
                
                Spacer()
                
                VStack {
                    DatePicker("Start Time", selection: $selectedStartTime, displayedComponents: .hourAndMinute)
                    DatePicker("End Time", selection: $selectedEndTime, displayedComponents: .hourAndMinute)
                }
                .padding()
            }
        }
        
        func angleForTime(_ date: Date) -> Angle {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            let totalMinutes = Double(components.hour!) * 60 + Double(components.minute!)
            let angle = (totalMinutes / (24 * 60)) * 360
            return .degrees(Double(angle))
        }
        
        func formatTime(_ time: Date) -> String {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter.string(from: time)
        }
    }

    struct HourMarker: View {
        var angle: Angle
        var hour:Int
        
        var body: some View {
            ZStack{
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 2, height: 10)
                    .offset(y: -120)
                    .rotationEffect(angle, anchor: .center)
                Text("\(hour)")
                    .offset(y: -150)
                    .rotationEffect(angle, anchor: .center)
            }
            
        }
    }

    struct ClockHand: View {
        
        var angle: Angle
        var color: Color
        
        var body: some View {
            Rectangle()
                .fill(color)
                .frame(width: 3, height: 100)
                .offset(y: -45)
                .rotationEffect(angle, anchor: .center)
        }
    }

    struct ClockArc: View {
        var startAngle: Angle
        var endAngle: Angle
        
        var body: some View {
            Circle()
                .trim(from: CGFloat(startAngle.degrees / 360), to: CGFloat(endAngle.degrees / 360))
                .stroke(Color.customCyan2, lineWidth: 10)
                .rotationEffect(.degrees(-90))
        }
    }

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct MapView:UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent: self)
    }

    @Binding var contry:String
    @Binding var city:String
    @Binding var title:String
    @Binding var subtitle:String
    @Binding var isChanged:Bool
    
    @Binding var region:MKCoordinateRegion

    func makeUIView(context: UIViewRepresentableContext<MapView>) ->MKMapView {

        let map = MKMapView()
        
        map.setRegion(region, animated: true)
        map.delegate = context.coordinator
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    }

    class Coordinator:NSObject,MKMapViewDelegate{



        var parent:MapView
        init(parent: MapView) {
            self.parent = parent

        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            DispatchQueue.main.async {
                self.parent.isChanged = true
            }
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
            let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)

            self.convertLocationToAddress(location: location)
                DispatchQueue.main.async {
                    self.parent.isChanged = false
                }
            }


        func convertLocationToAddress(location: CLLocation) {
                let geocoder = CLGeocoder()
                let locale = Locale(identifier: "ko")

                geocoder.reverseGeocodeLocation(location,preferredLocale: locale) { placemarks, error in
                    guard error == nil else{ return }

                    guard let placemark = placemarks?.first else { return }
                    self.parent.contry = "\(placemark.country ?? "")"
                    self.parent.city = "\(placemark.locality ?? "") \(placemark.name ?? "")"
                }
            }
    }
}

//import SwiftUI
//import MapKit
//
//struct TestView: View {
//    @State private var title = ""
//    @State private var subtitle = ""
//    @State private var country = ""
//    @State private var city = ""
//    @State private var isChanged = false
//    @State private var searchText = ""
//
//    @State private var fetchPlace: [CLPlacemark]?
//    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.298971, longitude: 127.354717), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            MapView(region: $region, title: $title, subtitle: $subtitle, isChanged: $isChanged,city: $city,country: $country)
//                .overlay {
//                    Image("where")
//                        .resizable()
//                        .frame(width: 60, height: 80)
//                        .offset(y: isChanged ? -50 : -40)
//                        .background {
//                            Capsule()
//                                .frame(width: 20, height: 15)
//                                .foregroundColor(.gray.opacity(0.5))
//                        }
//                }
//            VStack {
//                HStack {
//                    CustomTextField(placeholder: "", isSecure: false, color: .red, text: $searchText)
//                    Button("Move Map") {
//                        // Set new region value based on the button action (Seoul coordinates)
//                        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                    }
//                }
//
//                Text(country)
//                    .bold()
//                    .font(.title3)
//                Text(city)
//            }
//        }
//    }
//}
//
//struct TestView_Previews: PreviewProvider {
//    static var previews: some View {
//        TestView()
//    }
//}
//
//struct MapView: UIViewRepresentable {
//    @Binding var region: MKCoordinateRegion
//    @Binding var title: String
//    @Binding var subtitle: String
//    @Binding var isChanged: Bool
//    @Binding var city: String
//    @Binding var country: String
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(parent: self)
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
//        let map = MKMapView()
//        map.setRegion(region, animated: true) // Set initial region based on the binding
//        map.delegate = context.coordinator
//        return map
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
////        uiView.setRegion(region, animated: true) // Update the map view's region
//    }
//
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapView
//
//        init(parent: MapView) {
//            self.parent = parent
//        }
//
//        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//            DispatchQueue.main.async {
//                self.parent.isChanged = true
//            }
//        }
//
//        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//            let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
//            self.convertLocationToAddress(location: location)
//            DispatchQueue.main.async {
//                self.parent.isChanged = false
//            }
//        }
//
//        func convertLocationToAddress(location: CLLocation) {
//            let geocoder = CLGeocoder()
//            let locale = Locale(identifier: "ko")
//
//            geocoder.reverseGeocodeLocation(location, preferredLocale: locale) { placemarks, error in
//                guard error == nil else { return }
//
//                guard let placemark = placemarks?.first else { return }
//                self.parent.country = "\(placemark.country ?? "")"
//                self.parent.city = "\(placemark.locality ?? "") \(placemark.name ?? "")"
//            }
//        }
//    }
//}

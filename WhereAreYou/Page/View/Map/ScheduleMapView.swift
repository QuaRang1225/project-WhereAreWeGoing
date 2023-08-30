//
//  ScheduleMapView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/30.
//

import SwiftUI
import MapKit
import CoreLocationUI
import Kingfisher
import FirebaseFirestore

struct ScheduleMapView: View {
    
    @State var schedule:Schedule
    @State var region = MKCoordinateRegion()
    @Environment(\.dismiss) var dismiss
    @StateObject var location = LocationMagager()
    @EnvironmentObject var vm:PageViewModel
    
    var body: some View {
        ZStack(alignment: .top){
            Map(coordinateRegion: $region,showsUserLocation: true, annotationItems: vm.schedules) { anno in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: anno.location.latitude, longitude: anno.location.longitude)) {
                    Button {
                        self.schedule = anno
                        region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: anno.location.latitude, longitude: anno.location.longitude), span: location.mySpan)
                    } label: {
                        Image(systemName: LocationCategoryFilter.allCases.first(where: {$0.name == anno.category})?.image ?? "")
                            .font(.title)
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 10)
                            .background{
                                Circle()
                                    .frame(width: 50,height: 50)
                                    .foregroundColor(.customCyan2)
                            }
                    }
                }
            }.ignoresSafeArea()
            HStack{
                Button {
                    dismiss()
                } label: {
                    Circle()
                        .frame(width: 30,height: 30)
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .overlay {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                        .padding(.leading)
                }
                Spacer()
            }
            VStack(alignment: .trailing) {
                Button {
                    DispatchQueue.main.async {
                        withAnimation(.easeIn(duration: 0.5)){
                            region = MKCoordinateRegion(center:location.mapCoordinate, span: location.mySpan)
                        }
                    }
                } label: {
                    Circle()
                        .frame(width: 40,height: 40)
                        .foregroundColor(.white)
                        .shadow(color: .gray, radius: 10)
                        .overlay {
                            Image(systemName: "dot.viewfinder")
                                .foregroundColor(.black)
                        }
                }
                .padding()
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 200)
                    .foregroundColor(.white)
                    .overlay(alignment:.topLeading){
                        VStack(alignment: .leading){
                            HStack{
                                KFImage(URL(string: schedule.imageUrl ?? ""))
                                    .resizable()
                                    .frame(width: 70,height: 70)
                                    .scaledToFill()
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading,spacing: 5){
                                    Text("랜디스도넛")
                                        .bold()
                                        .font(.title3)
                                    Text(LocationCategoryFilter.allCases.first(where: {$0.name == schedule.category})?.name ?? "")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                            }
                            HStack{
                                Text(location.pickedPlaceMark?.locality ?? "")
                                Text(location.pickedPlaceMark?.thoroughfare ?? "")
                                Text(location.pickedPlaceMark?.subThoroughfare ?? "")
                            }
                            .foregroundColor(.black)
                            .font(.subheadline)
                            .padding(.bottom)
                            Group{
                                Text("일정 시작 : \(schedule.startTime.dateValue().toTimeString())")
                                Text("일정 끝 : \(schedule.endTime.dateValue().toTimeString())")
                            }.font(.title3)
                            
                        }
                        .padding()
                        .foregroundColor(.black)
                    }
                
                    .padding(.horizontal,10)
                    .shadow(radius: 10)
            }
            .frame(maxHeight: .infinity,alignment: .bottom)
        }
        .onChange(of: schedule) { newValue in
            location.updatePlacemark(location: CLLocation(latitude: newValue.location.latitude, longitude: newValue.location.longitude))
        }
        .onAppear{
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: schedule.location.latitude, longitude: schedule.location.longitude), span: location.mySpan)
            location.updatePlacemark(location: CLLocation(latitude: schedule.location.latitude, longitude: schedule.location.longitude))
        }
    }
}

struct ScheduleMapView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleMapView(schedule: CustomDataSet.shared.schedule())
            .environmentObject(PageViewModel())
    }
}



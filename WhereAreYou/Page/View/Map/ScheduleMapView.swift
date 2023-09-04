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
    
    
    @State var currentIndex = 0
    @State var copy = false
    @State var schedule:Schedule
    @State var region = MKCoordinateRegion()
    @Environment(\.dismiss) var dismiss
    @StateObject var location = LocationMagager()
    @EnvironmentObject var vm:PageViewModel
    
    
    var schedules:[Schedule]{
        return vm.schedules.sorted{$0.startTime < $1.startTime}
    }
    
    var body: some View {
        ZStack(alignment: .top){
            Map(coordinateRegion: $region,showsUserLocation: true, annotationItems: schedules) { anno in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: anno.location.latitude, longitude: anno.location.longitude)) {
                    Button {
                        self.schedule = anno
                        region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: anno.location.latitude, longitude: anno.location.longitude), span: location.mySpan)
                    } label: {
                        VStack{
                            if let index = schedules.firstIndex(of: anno){
                                HStack{
                                    Text("\(index + 1). ")
                                    Text("\(anno.title)")
                                }
                                .font(.caption)
                                .foregroundColor(.black)
                                .padding(5)
                                .background(Color.white).cornerRadius(5)
                                .shadow(radius: 10)
                                .offset(y:-25)
                                .onAppear{
                                    currentIndex = index
                                }
                            }
                                
                            KFImage(URL(string:anno.imageUrl ?? ""))
                                .resizable()
                                .frame(width: 45,height: 45)
                                .clipShape(Circle())
                                .font(.title)
                                .foregroundColor(.white)
                                .background{
                                    Circle()
                                        .frame(width: 50,height: 50)
                                }
                                .offset(y:-30)
                                .background {
                                    Image(systemName: "triangle.fill")
                                        .rotationEffect(Angle(degrees: 180))
                                }
                                .foregroundColor(.customCyan2)
                                
                        }
                    }
                }
            }.ignoresSafeArea()
                Capsule()
                    .foregroundColor(.white)
                    .frame(width: 250,height: 30)
                    .overlay {
                        HStack{
                            if location.pickedPlaceMark?.administrativeArea != location.pickedPlaceMark?.locality{
                                Text(location.pickedPlaceMark?.locality ?? "")
                            }   //서울특별시
                            Text(location.pickedPlaceMark?.thoroughfare ?? "")
                            Text(location.pickedPlaceMark?.subThoroughfare ?? "")
                        }.font(.subheadline).foregroundColor(.black)
                    }.shadow(radius: 10)
                
            
            
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
                HStack(alignment:.bottom){
                    Button {
                        copy = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            withAnimation{
                                copy = false
                            }
                        }
                        vm.copyToPasteboard(text: "\(location.pickedPlaceMark?.administrativeArea != location.pickedPlaceMark?.locality ? location.pickedPlaceMark?.locality ?? "": "") \(location.pickedPlaceMark?.thoroughfare ?? "") \(location.pickedPlaceMark?.subThoroughfare ?? "")")
                    } label: {
                        HStack(spacing:0){
                            Image(systemName: "square.on.square")
                            Text("주소복사")
                        }.padding(5).padding(.horizontal)
                        .font(.caption2)
                        .foregroundColor(.white).bold()
                    }.background(Color.gray.opacity(0.4)).cornerRadius(20).shadow(radius: 10)
                    Spacer()
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
                                    Text("\(currentIndex + 1). \(schedule.title)")
                                        .bold()
                                        .font(.title3)
                                    Text(LocationCategoryFilter.allCases.first(where: {$0.name == schedule.category})?.name ?? "")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                                Spacer()
                                VStack{
                                    Image(systemName: LocationCategoryFilter.allCases.first(where: {$0.name == schedule.category})?.image ?? "")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            HStack{
                                VStack(alignment: .leading){
                                    Text("일정 시작 : \(schedule.startTime.dateValue().toTimeString())")
                                    Text("일정 끝 : \(schedule.endTime.dateValue().toTimeString())")
                                }.font(.title3)
                                Spacer()
                                Button {
                                    withAnimation(.linear){
                                        currentIndex = (currentIndex - 1 + schedules.count) % vm.schedules.count
                                        schedule = schedules[currentIndex]
                                        region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: schedule.location.latitude, longitude: schedule.location.longitude), span: location.mySpan)
                                    }
                                } label: {
                                    Image(systemName: "chevron.left")
                                }.font(.title2)
                                    .padding(.trailing)
                                Button {
                                    withAnimation(.linear){
                                        currentIndex = (currentIndex + 1) % schedules.count
                                        schedule = schedules[currentIndex]
                                        region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: schedule.location.latitude, longitude: schedule.location.longitude), span: location.mySpan)
                                    }
                                } label: {
                                    Image(systemName: "chevron.right")
                                }.font(.title2)
                            }
                            .padding(.top,3)
                            .padding(.bottom)
                        }
                        .padding()
                        .foregroundColor(.black)
                    }
                
                    .padding(.horizontal,10)
                    .shadow(radius: 10)
            }
            .frame(maxHeight: .infinity,alignment: .bottom)
            if copy{
                Text("클립보드에 복사 되었습니다")
                    .foregroundColor(.white)
                    .padding(5)
                    .font(.caption)
                    .padding(.horizontal,30)
                    .background(Color.gray).cornerRadius(20)
                    .frame(maxHeight: .infinity)
            }
            
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



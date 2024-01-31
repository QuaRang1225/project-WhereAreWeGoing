//
//  AddScheduleView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI
import MapKit
import FirebaseFirestore

struct SearchAddressView: View {
    
    let startingOffset: CGFloat = UIScreen.main.bounds.height/2
    @State private var currentOffset:CGFloat = 0
    @State private var endOffset:CGFloat = 200
    
    @State var linkTitle:[String] = []
    @State var linkContents:[String] = []
    
    @State var isOpenSearchBar = false
    
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    @StateObject var location = LocationMagager()
    
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                header
                MapViewHelper()
                    .environmentObject(location)
                    .ignoresSafeArea()
                    .overlay {
                        Image("where")
                            .resizable()
                            .frame(width: 40,height: 50)
                            .offset(y:location.isChanged ? -35 : -25)
                            .background{
                                Capsule()
                                    .frame(width: 10,height: 5)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                        
                    }
                    .overlay(alignment:.topTrailing){
                        Button {
                            location.mapView.setRegion(MKCoordinateRegion(center:location.mapCoordinate, span: location.mySpan), animated: true)
                        } label: {
                            Circle()
                                .frame(width: 40,height: 40)
                                .foregroundColor(.white)
                                .shadow(color: .gray, radius: 5)
                                .overlay {
                                    Image(systemName: "dot.viewfinder")
                                        .foregroundColor(.black)
                                }
                        }
                        .padding()
                    }
                    .overlay(alignment: .top) {
                        if isOpenSearchBar{
                            searchList
                        }
                    }
            }
//            if !location.isChanged{
                Group{
                    if let schedule = vm.schedule{
                        AddScheduleView(title: schedule.title, text:schedule.content, locationSelect: LocationCategoryFilter.allCases.first(where: {$0.name == schedule.category}) ?? .cafe, links:linkContents, linktitles:linkTitle, startDate:schedule.startTime.dateValue(),endDate:schedule.endTime.dateValue(), scheduleImage: schedule.imageUrl ?? "")
                    }else{
                        AddScheduleView()
                    }
                }
                .environmentObject(vm)
                .environmentObject(location)
                .environmentObject(vmAuth)
                .cornerRadius(10)
                .offset(y:startingOffset - 100)
                .offset(y:currentOffset)
                .offset(y:endOffset)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            withAnimation(.spring()){
                                currentOffset = value.translation.height
                            }
                        }
                        .onEnded{ value in
                            withAnimation(.spring()){
                                offsetSetting()
                            }
                        }
                )
                .ignoresSafeArea(.all,edges: .bottom)
//            }
            if vm.copy{
                Text("클립보드에 복사되었습니다.")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(5)
                    .background{
                        Capsule()
                            .foregroundColor(.black)
                            .opacity(0.5)
                    }
                    .padding(.bottom)
                
            }
        }
        .ignoresSafeArea(.keyboard)
        .onChange(of: location.isChanged){ newValue in
            if newValue{
                withAnimation(.spring()){
                    endOffset = startingOffset - 20
                }
            }
        }
        .onChange(of: location.searchText){  newValue in
            isOpenSearchBar = true
        }
        .onReceive(vm.addDismiss) { _ in
            dismiss()
        }
        .onAppear{
            if let schedule = vm.schedule{
                if let links = schedule.link{
                    for i in links{
                        self.linkTitle.append(i.key)
                        self.linkContents.append(i.value)
                    }
                }
                let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: schedule.location.latitude, longitude: schedule.location.longitude), span: location.mySpan)
                location.mapView.setRegion(region, animated: true)
            }else{
                let region = MKCoordinateRegion(center: location.manager.location!.coordinate, span: location.mySpan)
                location.mapView.setRegion(region, animated: true)
            }
            
        }
        .onDisappear{
            vm.schedule = nil
        }
        
    }
}

struct SearchAddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SearchAddressView()
                .environmentObject(PageViewModel(page: nil, pages: CustomDataSet.shared.pages()))
                .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
                .environmentObject(LocationMagager())
        }
    }
}

extension SearchAddressView{
    var header:some View{
        ZStack(alignment: .top){
            Text(vm.schedule != nil ? "일정 수정" : "일정 추가")
                .bold()
            VStack{
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .bold()
                            .padding(.leading)
                        
                    }.shadow(color:.black,radius: 20)
                    Spacer()
                    
                }
                search.padding(.top,20)
                
            }
        }
        .foregroundColor(.black)
        .shadow(radius: 10)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
    var search:some View{
        VStack(alignment: .leading){
            CustomTextField(placeholder: "지번,도로명으로 검색..", isSecure: false,  text: $location.searchText)
                .padding(.horizontal)
            
            
        }
    }
    
    
    var searchList:some View{
        VStack{
            if let place = location.fetchPlace, !place.isEmpty{
                List{
                    ForEach(place,id: \.self){ place in
                        Button {
                            if let coordinate = place.location?.coordinate{
                                location.pickedLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
                                location.updatePlacemark(location: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
                                location.mapView.setRegion( MKCoordinateRegion(center: coordinate, span: location.mySpan), animated: true)
                                isOpenSearchBar = false
                            }
                            //                            isAddress = true
                        } label: {
                            HStack(spacing:15){
                                Image("where")
                                    .resizable()
                                    .frame(width: 20,height: 25)
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading){
                                    Text(place.name ?? "")
                                        .bold()
                                    HStack(spacing: 5){
                                        Text(place.country ?? "")
                                            .foregroundColor(.black)
                                        Text(place.administrativeArea ?? "")
                                        if place.administrativeArea != place.locality{
                                            Text(place.locality ?? "")
                                        }   //서울특별시
                                        Text(place.thoroughfare ?? "")
                                        Text(place.subThoroughfare ?? "")
                                    }
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                }
                            }
                        }
                    }.listRowBackground(Color.clear)
                }.listStyle(.plain)
                    .scrollContentBackground(.hidden)
            }
        }
        .background(Color.white)
        .foregroundColor(.black)
        .cornerRadius(10)
        .frame(maxHeight: UIScreen.main.bounds.height/2)
        .offset(y:-10)
        
    }
    func offsetSetting(){
       
        if endOffset ==  startingOffset - 20{
            if currentOffset <  50{
                endOffset = 200
            }
        }
        else if endOffset <= 200 {
            if currentOffset <  50{
                endOffset = -startingOffset + 100
            }
            else if currentOffset > 50{
                endOffset = 200
            }
        }
       
       
        currentOffset = 0
    }
    
}


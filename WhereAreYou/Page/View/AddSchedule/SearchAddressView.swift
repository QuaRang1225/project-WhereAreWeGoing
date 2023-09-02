//
//  AddScheduleView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI
import MapKit

struct SearchAddressView: View {
    

    @State var modifyButton = false
    @State var modifySchedlue = false
    
    @State var isAddress = false
    @Binding var isSearch:Bool
    
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var location:LocationMagager
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            header
        }
        .onAppear{
            if vm.modifingSchecdule != nil{
                modifyButton = true
            }
        }
        .confirmationDialog("일정 수정", isPresented: $modifyButton, actions: {
            Button(role:.none){
                modifySchedlue = true
            } label: {
                Text("건너뛰기")
            }
        },message: {
            Text("위치정보 수정을 건너 뛰시겠습니까?")
        })
        .navigationDestination(isPresented: $isAddress) {
            SelectAddressView(isPage: $isSearch)
                .environmentObject(vm)
                .environmentObject(location)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $modifySchedlue) {
            AddScheduleView(isPage: $isSearch)
                .environmentObject(vm)
                .environmentObject(location)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }
        
    }
}

struct SearchAddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SearchAddressView(isSearch: .constant(false))
                .environmentObject(PageViewModel())
                .environmentObject(AuthViewModel())
                .environmentObject(LocationMagager())
        }
    }
}

extension SearchAddressView{
    var header:some View{
        ZStack(alignment: .top){
            Text("주소 검색")
                .font(.title3)
                .bold()
            VStack{
                HStack{
                    Button {
                        isSearch = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .bold()
                            .padding(.leading)
                        
                    }.shadow(color:.black,radius: 20)
                    Spacer()
                    
                }
                search.padding(.top,30)
                searchList
                    
                
            }
            
        }
        .foregroundColor(.black)
        .frame(maxHeight: .infinity,alignment: .top)
        
    }
    var search:some View{
        VStack(alignment: .leading){
            HStack{
                CustomTextField(placeholder: "지번,도로명으로 검색..", isSecure: false, color: .gray.opacity(0.8), text: $location.searchText)
                Button {
                    location.fetchPlaces(value: location.searchText)
                } label: {
                    Text("검색")
                }
                .padding(.trailing)
            }
            Button {
                location.updatePlacemark(location: .init(latitude: location.mapRegion.center.latitude, longitude: location.mapRegion.center.longitude))
                isAddress = true
            } label: {
                HStack{
                    Image(systemName: "location.fill")
                    Text("현재 위치로")
                }
                
            }
            .padding(.leading)
            .padding(.top,10)
            
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
                                location.mapRegion = MKCoordinateRegion(center: coordinate, span: location.mySpan)
                            }
                            isAddress = true
                        } label: {
                            HStack(spacing:15){
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
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
        .foregroundColor(.black)
    }
}


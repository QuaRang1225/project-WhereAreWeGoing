//
//  AddScheduleView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI
import MapKit

struct AddScheduleView: View {
    
    
    @State var city:[String] = []
    @State var country:[String] = []
    @State var fetchPlace:[CLPlacemark]?
    @StateObject var location = LocationMagager()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            header
            searchList
        }
        
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AddScheduleView()
        }
    }
}

extension AddScheduleView{
    var header:some View{
        ZStack(alignment: .top){
            Text("주소 검색")
                .font(.title3)
                .bold()
            VStack{
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .bold()
                        
                            .padding(.leading)
                        
                    }.shadow(color:.black,radius: 20)
                    Spacer()
                    
                }
                search
                    .padding(.top,30)
                
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
            NavigationLink {
                
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
                            }
                        } label: {
                            HStack(spacing:15){
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                VStack(alignment: .leading){
                                    Text(place.name ?? "")
                                        .font(.title3.bold())
                                    Text(place.locality ?? "")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }.listRowBackground(Color.clear)
                }.listStyle(.plain)
                    .scrollContentBackground(.hidden)
            }else{
                HStack{
                    Button {
                        location.updatePlacemark(location: .init(latitude: location.mapRegion.center.latitude, longitude: location.mapRegion.center.longitude))
                    } label: {
                        Label {
                            Text("현재 위치")
                                .font(.callout)
                        } icon: {
                            Image(systemName: "mappin.circle.fill")
                        }.foregroundColor(.white)
                            .frame(maxWidth: .infinity,alignment: .trailing).padding(.trailing)
                    }
                }
            }
        }
    }
}


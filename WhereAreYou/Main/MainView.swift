//
//  MainView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import CoreLocationUI
import MapKit


struct MainView: View {
    @StateObject var location = LocationMagager()
    var body: some View {
        VStack(alignment: .leading){
            
            HStack(spacing: 20){
                Text("메인화면")
                    .font(.title)
                Spacer()
                Image(systemName: "magnifyingglass")
                Image(systemName: "person.badge.plus")
            }
            .font(.title3)
            .padding(.horizontal)
            .bold()
            
            List{
                Map(coordinateRegion: $location.mapRegion ,showsUserLocation: true)
                    .frame(height:100)
                    .cornerRadius(20)
                    .listRowSeparator(.hidden)  //리스트 줄 없앰
                    .listRowBackground(Color.clear)

                ForEach(0...50,id:\.self){ _ in
                    Text("asddasd")
                }
                .listRowBackground(Color.clear)
                
                
            }
            .listStyle(.plain)
        }
        .foregroundColor(.black)
        .background(Color.white)

        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}




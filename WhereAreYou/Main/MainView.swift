//
//  MainView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import CoreLocationUI
import MapKit
import Kingfisher

struct MainView: View {
    @StateObject var location = LocationMagager()
    @EnvironmentObject var vm:AuthViewModel
    var body: some View {
        VStack(alignment: .leading){
            
            HStack(spacing: 20){
                Text("메인화면")
                    .font(.title)
                Spacer()
                NavigationLink{
                    SearchView()
                }label: {
                    Image(systemName: "magnifyingglass")
                }
                Button {
                    
                } label: {
                    Image(systemName: "person.badge.plus")
                }

                
            }
            .font(.title3)
            .padding(.horizontal)
            .bold()
            
            List{
                Map(coordinateRegion: $location.mapRegion ,interactionModes: [], showsUserLocation: true)
                    .frame(height:100)
                    .cornerRadius(20)
                    .listRowSeparator(.hidden)  //리스트 줄 없앰
                    .listRowBackground(Color.clear)
                Section("내 프로필") {
                    ProfileRowView(image: vm.user?.profileImageUrl ?? "", name: vm.user?.nickName ?? "")
                        .listRowSeparator(.hidden)  //리스트 줄 없앰
                        .listRowBackground(Color.clear)
                }
                .foregroundColor(.gray)
                .font(.caption)
                
                Section("즐겨찾기"){
                    ForEach(0...5,id:\.self){ _ in
                        ProfileRowView(image: CustomDataSet.shared.basicImage, name: "으딩이\(Range(1...10).randomElement() ?? 1)")
                            .listRowSeparator(.hidden)  //리스트 줄 없앰
                    }
                    .listRowBackground(Color.clear)
                }
                .foregroundColor(.gray)
                .font(.caption)
                
                Section("친구"){
                    ForEach(0...50,id:\.self){ _ in
                        ProfileRowView(image: CustomDataSet.shared.basicImage, name: "으딩이\(Range(1...10).randomElement() ?? 1)")
                            .listRowSeparator(.hidden)  //리스트 줄 없앰
                    }
                    .listRowBackground(Color.clear)
                }
                .foregroundColor(.gray)
                .font(.caption)
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
            .environmentObject(AuthViewModel())
    }
}




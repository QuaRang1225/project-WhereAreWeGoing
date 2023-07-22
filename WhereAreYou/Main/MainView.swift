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
    let columns = [GridItem(),GridItem()]
    @State var area:TravelFilter = .all
    @StateObject var location = LocationMagager()
    @EnvironmentObject var vm:AuthViewModel
    var body: some View {
        VStack(alignment: .leading){
            
            HStack(spacing: 20){
                Text("내 여행")
                    .font(.title)
                Spacer()
                NavigationLink{
                    SearchView()
                }label: {
                    Image(systemName: "magnifyingglass")
                }
                NavigationLink {
                    SelectTypeView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(systemName: "plus.viewfinder")
                }
            }
            .font(.title3)
            .padding(.horizontal)
            .bold()
            
            List{
                Section("내 프로필") {
                    ProfileRowView(image: vm.user?.profileImageUrl ?? "", name: vm.user?.nickName ?? "")
                        .listRowSeparator(.hidden)  //리스트 줄 없앰
                        .listRowBackground(Color.clear)
                }
                .foregroundColor(.gray)
                .font(.body)
                
                ScrollView(.horizontal,showsIndicators: false){
                    HStack{
                        ForEach(TravelFilter.allCases,id:\.self){ item in
                            Button {
                                area = item
                            } label: {
                                Text(item.name)
                                    .bold()
                                    .padding(.horizontal)
                                    .foregroundColor(area == item ? .white:.customCyan2)
                                    .padding(10)
                                    .background{
                                        if area == item{
                                            Capsule()
                                                .foregroundColor(.customCyan2)
                                        }else{
                                            Capsule()
                                                .stroke(lineWidth: 3)
                                                .foregroundColor(.customCyan2)
                                        }
                                    }
                            }
                        }
                        
                    }
                    .padding(5)
                    
                }.listRowBackground(Color.clear)
                LazyVGrid(columns: columns) {
                    ForEach(0...10,id:\.self){ _ in
                        VStack{
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height:200)
                            Text("제주도")
                        }
                    }
                }.listRowBackground(Color.clear)
                
//                Section("친구"){
//                    ForEach(0...50,id:\.self){ _ in
//                        ProfileRowView(image: CustomDataSet.shared.images.randomElement()!, name: "으딩이\(Range(1...10).randomElement() ?? 1)")
//                            .listRowSeparator(.hidden)  //리스트 줄 없앰
//                    }
//                    .listRowBackground(Color.clear)
//                }
//                .foregroundColor(.gray)
//                .font(.body)
            }
            .listStyle(.plain)
        }
        .foregroundColor(.black)
        .background(Color.white)
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MainView()
                .environmentObject(AuthViewModel())
        }
    }
}




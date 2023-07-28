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
    @StateObject var vm = PageViewModel()
    @EnvironmentObject var vmAuth:AuthViewModel
    
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
                NavigationLink {
                    SelectTypeView()
                        .environmentObject(vmAuth)
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(systemName: "plus.viewfinder")
                }
            }
            .font(.title3)
            .padding(.horizontal)
            .bold()
            
            ScrollView{
                Section("내 프로필"){
                    NavigationStack{
                        ProfileRowView(image: vmAuth.user?.profileImageUrl ?? "", name:vmAuth.user?.nickName ?? "", email: vmAuth.user?.email ?? "")
                            .listRowSeparator(.hidden)  //리스트 줄 없앰
                            .listRowBackground(Color.clear)
                    }
                }
                .font(.body)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding()
                .bold()
                Section("내 일정"){
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
                        .padding(.vertical,2)
                        .padding(.horizontal,2)
                    }.listRowBackground(Color.clear)
                    LazyVGrid(columns: columns) {
                        ForEach(vm.pages,id:\.self){ page in
                            NavigationLink {
                                PageMainView(page: page)
                                    .environmentObject(vm)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                PageRowView(image:  page.pageImageUrl, title: page.pageName)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .onAppear{
                        if let user = vmAuth.user{
                            vm.getPages(user: user)
                        }
                    }
                }
                .bold()
                .font(.body)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding()
            }
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




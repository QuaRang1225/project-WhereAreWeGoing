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
    
    var selectFilter:[Page]{
        if area == .domestic{
            return vm.pages.filter({$0.pageOverseas == false})
        }else if area == .overseas{
            return vm.pages.filter({$0.pageOverseas == true})
        }else{
            return vm.pages
        }
    }
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            
            HStack(spacing: 20){
                Image("lofo")
                    .resizable()
                    .frame(width: 120,height: 30)
                Spacer()
                NavigationLink{
                    SearchView()
                }label: {
                    Circle()
                        .frame(width: 40,height: 40)
                        .shadow(radius: 3)
                        .foregroundColor(.white)
                        .overlay{
                            Image(systemName: "magnifyingglass")
                        }
                }
                NavigationLink {
                    SelectTypeView()
                        .environmentObject(vmAuth)
                        .navigationBarBackButtonHidden()
                } label: {
                    Circle()
                        .frame(width: 40,height: 40)
                        .foregroundColor(.white)
                        .shadow(radius: 3)
                        .overlay{
                            Image(systemName: "plus.viewfinder")
                        }
                }
            }
            .font(.title3)
            .padding(.horizontal)
            .bold().padding(.bottom,10)
            Divider()
            ScrollView{
                VStack(spacing: 0){
                    Text("내 프로필").font(.subheadline).padding(.leading)
                        .bold()
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                   
                    Divider()
                        .padding(5)
                    NavigationStack{
                        if let user = vmAuth.user{
                            ProfileRowView(image: user.profileImageUrl ?? "", name:user.nickName ?? "", email: user.email ?? "")
                                .listRowSeparator(.hidden)  //리스트 줄 없앰
                                .listRowBackground(Color.clear)
                        }else{
                            ProfileRowView(image: CustomDataSet.shared.basicImage, name:"콰랑", email: "ㅇㅁㄴㅇㅁㄴㅇ")
                                .listRowSeparator(.hidden)  //리스트 줄 없앰
                                .listRowBackground(Color.clear)
                        }
                       
                    }
                }.background(Color.white.frame(height: 130)
                    .cornerRadius(10).shadow(radius: 1, y: 2))
                .padding(5)
                .padding(.top,40)
                VStack(alignment: .leading){
                    Text("내 일정").font(.subheadline).bold()
                        .padding(.top,30)
                        ScrollView(.horizontal,showsIndicators: false){
                            HStack{
                                ForEach(TravelFilter.allCases,id:\.self){ item in
                                    Button {
                                        area = item
                                    } label: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(width: 100,height: 30)
                                            .shadow(radius: 2,y:2)
                                            .foregroundColor(item == area ? .gray.opacity(0.3):.white)
                                            .overlay{
                                                HStack(spacing: 3) {
                                                    Text(item.image)
                                                    Text(item.name)
                                                }
                                                .bold()
                                                .font(.caption)
                                                .foregroundColor(.black)
                                            }
                                            .padding(.vertical,3)
                                    }
                                }
                            }
                        }
                    .bold()
                    .font(.body)
                    .frame(maxWidth: .infinity,alignment: .leading)
                }.padding(.horizontal,7.5)
                
                VStack(spacing:0){
                    ForEach(selectFilter,id:\.self){ page in
                        NavigationLink {
                            PageMainView(page: page)
                                .environmentObject(vm)
                                .environmentObject(vmAuth)
                                .navigationBarBackButtonHidden()
                        } label: {
                            PageRowView(page:page)
                        }
                        if page != selectFilter.last{
                            Divider()
                        }
                    
                    }
                    .padding(5)
                    
                    
                }
                .background(Color.white).cornerRadius(10)
                .shadow(radius:1,y:2)
                .padding(.horizontal,5)
                
                
            }
            .background(Color.gray.opacity(0.1))
        }
        .foregroundColor(.black)
        .background(Color.white)
        .onAppear{
            if let user = vmAuth.user{
                vm.getPages(user: user)
            }
        }
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




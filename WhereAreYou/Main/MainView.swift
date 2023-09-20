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
            }
            .font(.title3)
            .padding(.horizontal)
            .bold().padding(.bottom,10)
            Divider()
            ScrollView{
                profile
                search
                collection
                filter
                page
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
//        .onReceive(vm.deleteSuccess) {
//            if let user = vmAuth.user{
//                vm.getPages(user: user)
//            }
//        }
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

extension MainView{
    var profile:some View{
        VStack{
            Text("내 프로필").font(.subheadline).padding(.leading)
                .bold()
                .frame(maxWidth: .infinity,alignment: .leading).padding(.top,30)
            VStack(spacing: 0){
                NavigationStack{
                    if let user = vmAuth.user{
                        ProfileRowView(image: user.profileImageUrl ?? "", name:user.nickName ?? "", email: user.email ?? "")
                            .listRowSeparator(.hidden)  //리스트 줄 없앰
                            .listRowBackground(Color.clear)
                    }
//
                   
                }
            }.background(Color.white.frame(height: 100)
                .cornerRadius(10).shadow(radius: 0.5, y: 1))
            .padding(10)
            .padding(.top,15)
            
        }
    }
    
    var search:some View{
        NavigationLink{
            SearchView()
                .environmentObject(vm)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }label: {
            Capsule()
                .frame(height: 50)
                .shadow(radius: 1)
                .foregroundColor(.white)
                .overlay(alignment:.leading){
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .padding(.leading)
                        Text("찾으시는 페이지가 있으세요?").font(.subheadline).foregroundColor(.gray.opacity(0.5))
                    }
                }
        }.padding(.top,30).padding(.horizontal,10)
    }
    
    var collection:some View{
        HStack{
            NavigationLink {
                AddPageView()
                    .environmentObject(vm)
                    .environmentObject(vmAuth)
                    .navigationBarBackButtonHidden()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 100)
                    .foregroundColor(.cyan.opacity(0.1))
                    .shadow(radius: 1)
                    .overlay{
                        Circle()
                            .overlay{
                                Circle()
                                    .offset(x:40)
                                    .padding()
                            }
                            .overlay{
                                Circle()
                                    .offset(x:-40)
                                    .padding(25)
                            }
                            .foregroundColor(.white)
                            .padding(10)
                        VStack{
                            Image("travel")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(alignment:.bottom){
                                    Ellipse()
                                        .frame(height:3)
                                        .foregroundColor(.black.opacity(0.5))
                                        .offset(y:1)
                                }
                            Text("여행추가")
                               .bold()
                               .font(.caption)
                        }
                        
                    }
            }
            NavigationLink {
                CalenderView()
                    .environmentObject(vm)
                    .navigationBarBackButtonHidden()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 100)
                    .foregroundColor(.white)
                    .shadow(radius: 0.3)
                    .overlay{
                        VStack{
                            Image("calender")
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("일정확인")
                                .bold()
                                .font(.caption)
                        }
                    }
            }

        }.padding(.horizontal,10).padding(.top,10)
    }
    var filter:some View{
        VStack(alignment: .leading){
            Text("내 일정").font(.subheadline).bold()
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
            .padding(.top,10)
    }
    var page:some View{
        VStack(spacing:0){
            ForEach(selectFilter,id:\.self){ page in
                NavigationLink {
                    PageMainView(page: page)
                        .environmentObject(vm)
                        .environmentObject(vmAuth)
                        .navigationBarBackButtonHidden()
                        .onAppear{
                            print(page)
                        }
                } label: {
                    PageRowView(page:page)
                }
                if page != selectFilter.last{
                    Divider()
                }
            
            }
            .padding(10)
            
            
        }
        .background(Color.white).cornerRadius(10)
        .shadow(radius:1,y:2)
        .padding(.horizontal,5)
    }
}




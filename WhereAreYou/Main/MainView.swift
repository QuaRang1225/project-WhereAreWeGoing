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
    
    @State var currentPage = 0
    @GestureState var dragOffset:CGFloat = 0
    
    
    @State var profile = false
    @State var area:TravelFilter = .all
    @StateObject var location = LocationMagager()
    @StateObject var vm = PageViewModel(page: nil, pages: [])
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
            header
            
            HStack{
                VStack(alignment: .leading){
                    if let user = vmAuth.user {
                        Group{
                            Text((user.nickName ?? "") + "님,")
                            Text("안녕하세요.")
                                .padding(.bottom,10)
                        }
                        .foregroundColor(.black)
                        .font(.title2)
                        Group{
                            Text("여행을 추가하여 리더가 되고,")
                            Text("여행을 찾아 팀원이 될 수 있어요.")
                                .padding(.bottom)
                        }
                        .foregroundColor(.black.opacity(0.7))
                        
                    }
                    button()
                    
                }
                .padding(.leading)
                Spacer()
                Image("triper")
                    .resizable()
                    .frame(width: 150,height: 220)
            }
            .bold()
            .padding(.top)
            .padding(.bottom)
            search
            page
        }
        .sheet(isPresented: $profile){
            ProfileChangeView()
        }
        .background(Color.white)
        .onAppear{
            guard let user = vmAuth.user else {return}
            vm.getPages(user: user)
            
        }
        .refreshable {
            guard let user = vmAuth.user else {return}
            vm.getPages(user: user)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            MainView(vm:PageViewModel(page: nil, pages: CustomDataSet.shared.pages()))
                .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
        }
    }
}

extension MainView{
    var header:some View{
        HStack(spacing: 20){
            Image("lofo")
                .resizable()
                .frame(width: 120,height: 30)
            Spacer()
            Button {
                profile = true
            } label: {
                if let profile = vmAuth.user?.profileImageUrl{
                    KFImage(URL(string: (profile)))
                        .resizable()
                        .frame(width: 50,height: 50)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                }else{
                    ProgressView()
                        .environment(\.colorScheme, .light)
                }
                
            }
            
        }
        .font(.title3)
        .padding(.horizontal)
        .bold()
        .padding(.bottom,10)
    }
    
    func button() -> some View{
        HStack{
            NavigationLink{
                AddPageView()
                    .environmentObject(PageViewModel(page: nil, pages: CustomDataSet.shared.pages()))
                    .environmentObject(vmAuth)
                    .navigationBarBackButtonHidden()
            } label:{
                Capsule()
                    .frame(width: 100,height: 50)
                    .foregroundColor(.customCyan3)
                    .overlay {
                        Text("여행 추가")
                            .foregroundStyle(.white)
                    }
            }
            NavigationLink{
                CalenderView()
                    .environmentObject(vm)
                    .navigationBarBackButtonHidden()
            } label:{
                Capsule()
                    .stroke(lineWidth: 1)
                    .frame(width: 100,height: 50)
                    .overlay {
                        Text("여행 일정")
                    }
                    .foregroundColor(.customCyan3)
            }
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
                            .foregroundColor(.gray)
                        Text("찾으시는 페이지가 있으세요?").font(.subheadline).foregroundColor(.gray.opacity(0.5))
                    }
                }
        }.padding(.top,30).padding(.horizontal,10)
    }
    var page:some View{
        VStack(alignment: .leading){
            VStack(alignment:.leading){
                Text("내 페이지")
                    .font(.title2)
                    .padding(.bottom)
                HStack{
                    VStack(alignment:.leading){
                        Text(selectFilter[currentPage].pageName)
                        Text(selectFilter[currentPage].pageSubscript)
                            .font(.subheadline)
                            .opacity(0.6)
                    }
                    Spacer()
                    Text("D-15")
                        .font(.largeTitle)
                }
                
            }
            .bold()
            .padding()
            .foregroundColor(.black)
            Spacer()
            ZStack{
                ForEach(0..<selectFilter.count,id:\.self){ index in
                    NavigationLink {
                        PageMainView(page: selectFilter[index])
                            .environmentObject(vm)
                            .environmentObject(vmAuth)
                            .navigationBarBackButtonHidden()
                    } label: {
                        KFImage(URL(string: selectFilter[index].pageImageUrl ?? ""))
                            .resizable()
                            .frame(width:290,height: 200)
                            .shadow(radius: 5)
                            .opacity(currentPage == index ? 1.0 : 0.5)
                            .scaleEffect(currentPage == index ? 1.2 : 0.8)
                            .cornerRadius(10)
                            .offset(x:CGFloat(index - currentPage) * 300 + dragOffset)
                    }
                    
                }
            }
            .frame(maxWidth:.infinity)
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        let threshold:CGFloat = 50
                        if value.translation.width > threshold{
                            withAnimation {
                                currentPage = max(0,currentPage - 1)
                            }
                        }else if value.translation.width < -threshold{
                            withAnimation {
                                currentPage = min(CustomDataSet.shared.images.count-1,currentPage + 1)
                            }
                        }
                    })
            )
            .padding(.bottom,20)
        }
        
    }
}




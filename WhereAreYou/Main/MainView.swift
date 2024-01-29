//
//  MainView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import Kingfisher

struct MainView: View {
    
    @State var currentPageIndex = 0
    @GestureState var dragOffset:CGFloat = 0
    @State var currentPage:Page?
    
    @State var profile = false
    @State var area:TravelFilter = .all
    
    @StateObject var vm = PageViewModel(page: nil, pages: [])
    @EnvironmentObject var vmAuth:AuthViewModel
    
    let columns = [ GridItem(.flexible()),
                    GridItem(.flexible())]
    
    
    
//    var sortedPages:[Page]{
//        return vm.pages.sorted(by: {$0.dateRange.first?.dateValue() ?? Date() < $1.dateRange.last?.dateValue() ?? Date()})
//    }
    func relativeTime(page:Page) ->String{
        if let day = page.dateRange.first?.dateValue().calculateDaysDifference(){
            if day > 0{
                return "D-\(day)"
            }
            else if day < 0{
                return "D+\(-day)"
            }
            else{
                return "오늘"
            }
        }
        return "알수 없음"
    }
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            header
            ScrollView(showsIndicators: false){
                contents
                search
                page
            }
        }
        .sheet(isPresented: $profile){
            ProfileChangeView(nickname:vmAuth.user?.nickName ?? "",profile:vmAuth.user?.profileImageUrl ?? "", preProfile:vmAuth.user?.profileImagePath != nil ? (vmAuth.user?.profileImageUrl ?? "") : "")
        }
        .background{
            Color.gray.opacity(0.1).ignoresSafeArea()
        }
        .onAppear{
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
                        .frame(width: 40,height: 40)
                        .scaledToFill()
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
                    .environmentObject(vm)
                    .environmentObject(vmAuth)
                    .navigationBarBackButtonHidden()
            } label:{
                Capsule()
                    .frame(width: 100,height: 50)
                    .foregroundColor(.customCyan3)
                    .overlay {
                        Text("여행 추가")
                            .foregroundColor(.white)
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
        }.padding(.top,30).padding(.horizontal)
    }
    var page:some View{
        VStack(alignment: .leading){
            Text("내 페이지")
                .font(.title2)
                .padding(.bottom)
                .foregroundColor(.black)
                .bold()
            LazyVGrid(columns: columns){
                ForEach(vm.pages.sorted(by: {$0.dateRange.first?.dateValue() ?? Date() < $1.dateRange.first?.dateValue() ?? Date()}),id:\.self){ page in
                    NavigationLink {
                        PageMainView(pageId: page.pageId)
                            .environmentObject(vm)
                            .environmentObject(vmAuth)
                            .navigationBarBackButtonHidden()
                    }label:{
                        VStack(alignment: .leading){
                            HStack{
                                Text(relativeTime(page:page))
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(.black)
                                Spacer()
                                Text(page.dateRange.first?.dateValue().toString() ?? "")
                                    .font(.caption)
                                    .foregroundColor(.black)
                            }
                            
                            VStack{
                                KFImage(URL(string: page.pageImageUrl ?? ""))
                                    .resizable()
                                    .frame(height: UIScreen.main.bounds.width/3)
                                Text(page.pageName)
                                    .foregroundColor(.black)
                                Text(page.pageSubscript)
                                    .lineLimit(1)
                                    .foregroundColor(.black.opacity(0.7))
                                    .font(.subheadline)
                                    .opacity(0.6)
                                    .padding(.bottom,5)
                            }
                            .background(Color.white)
                            .cornerRadius(10)
                        }
                    }
                }
            }
           
        }
        .padding()
        
    }
    var contents:some View{
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
    }
}




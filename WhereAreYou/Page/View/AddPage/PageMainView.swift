//
//  PageMainView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import SwiftUI
import Kingfisher


struct PageMainView: View {
    
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    @State var pageMode:PageTabFilter = .schedule
    @State var isSearch = false
    @State var page:Page

    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack{
            ScrollView(.vertical,showsIndicators: false){
                VStack{
                    background
                    ZStack{
                        switch pageMode {
                        case .schedule:
                            SchduleListView(page: $page)
                                .environmentObject(vmAuth)
                        case .member:
                            MemberTabView()
                        case .setting:
                            Text("")
                        }
                    }.environmentObject(vm)
                    
                }
            }
            .foregroundColor(.black)
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
            header
            tabBar
            
        }
        .navigationDestination(isPresented: $isSearch){
            SearchAddressView(isSearch: $isSearch)
                .environmentObject(vm)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }
        .onAppear{
            Task{
                vm.admin = try await UserManager.shared.getUser(userId: page.pageAdmin)
                vm.page = page
            }
        }
    }
}

struct PageMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PageMainView(page: CustomDataSet.shared.page())
                .environmentObject(PageViewModel())
                .environmentObject(AuthViewModel())
        }
    }
}
extension PageMainView{
    
    var header:some View{
        HStack{
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.title3)
                    .bold()
                    
                    .padding(.leading)
                    
            }.shadow(color:.black,radius: 20)
            Spacer()
            Image(systemName: "person.badge.plus")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.trailing)
        }
        .frame(maxHeight: .infinity,alignment: .top)
    }
    var tabBar:some View{
        VStack(alignment: .leading){
            
            
            VStack{
                Divider()
                    .background(Color.black)
                    .padding(.bottom)
                HStack(spacing: 0){
                    Group{
                        ForEach(PageTabFilter.allCases,id:\.self){ tabItem in
                            Button {
                                pageMode = tabItem
                            } label: {
                                Text(tabItem.name)
                                    .font(.caption)
                                    .overlay {
                                        Image(systemName: tabItem.image)
                                            .padding(.bottom,40)
                                    }
                                    .foregroundColor(pageMode == tabItem ?  .customCyan2 : .gray.opacity(0.7))
                                    .padding(.top)
                                    .bold()
                            }
                        }
                    }.frame(maxWidth: .infinity)
                }
            }.background(Color.white)
                
        }
        
        .frame(maxHeight: .infinity,alignment: .bottom)
    }
    var background:some View{
        ZStack(alignment: .bottomTrailing){
            GeometryReader { pro in
                KFImage(URL(string: page.pageImageUrl)!)
                    .resizable()
                    .overlay{
                        Color.black.opacity(0.3)
                    }
                    .offset(x: pro.frame(in: .global).minY > 0 ? -pro.frame(in: .global).minY : 0,
                                y: pro.frame(in: .global).minY > 0 ? -pro.frame(in: .global).minY : 0)
                            .frame(
                                width: pro.frame(in: .global).minY > 0 ?
                                    UIScreen.main.bounds.width + pro.frame(in: .global).minY * 2 :
                                    UIScreen.main.bounds.width,
                                height: pro.frame(in: .global).minY > 0 ?
                                    UIScreen.main.bounds.height/3 + pro.frame(in: .global).minY :
                                    UIScreen.main.bounds.height/3
                            )
            }
            HStack(alignment: .bottom){
                Button {
                    isSearch = true
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(width: 100,height: 40)
                        .shadow(radius: 10)
                        .overlay {
                            HStack{
                                Image(systemName: "plus.app.fill")
                                    .font(.body)
                                Text("일정 추가")
                                    .font(.caption)
                                    .bold()
                            }.foregroundColor(.customCyan2)
                            
                        }
                }
                .padding()
                Spacer()
                VStack(alignment: .trailing,spacing: 5){
                    HStack{
                        if page.pageOverseas{
                            Text("🌏")
                        }else{
                            Text("🇰🇷")
                        }
                        Text(page.pageName)
                            .font(.title)
                            .bold()
                    }
                    
                    Text(page.pageSubscript)
                        .font(.callout)
                }
                .foregroundColor(.white)
                .padding(.trailing)
                .offset(y:-10)
            }
            
            
           
        }
        .frame(height: UIScreen.main.bounds.height/3)
    }
}



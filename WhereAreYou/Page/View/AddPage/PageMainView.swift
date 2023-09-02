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
    @State var page:Page
    
    @State var photo = false
    @State var binding:Schedule?

    @State var currentAmount:CGFloat = 0
    @State var currentDrageAmount:CGFloat = 0
    
    
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack{
            ScrollView(.vertical,showsIndicators: false){
                VStack{
                    background
                    ZStack{
                        switch pageMode {
                        case .schedule:
                            SchduleListView(page: $page,binding: $binding, photo: $photo)
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
            .padding(.bottom,30)
            header
            tabBar
            if vm.copy{
                Text("클립보드에 복사되었습니다.")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(5)
                    .background{
                        Capsule()
                            .foregroundColor(.black)
                            .opacity(0.5)
                    }
                    .padding(.bottom)
                    
            }
            if photo{
                Color.black.ignoresSafeArea().opacity(0.6).onTapGesture {
                    photo = false
                }
                KFImage(URL(string: binding?.imageUrl ?? ""))
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1 + currentAmount)
                    .offset(y: currentDrageAmount)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                currentAmount = value - 1
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    currentAmount = 0
                                }
                            }
                    )

            }
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
            Button {
                //페이지 수정/삭제
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.trailing)
            }

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
                VStack{
                    VStack{
                        Text("⏱️현재 시간").font(.caption).bold()
                        Text("\(currentTime.toStringCalender())")
                            .font(.caption)
                        Text("\(currentTime.toTimeHourMinuteSecond())")
                    }
                    
                    .foregroundColor(.black)
                    .bold()
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 1)
                    .onReceive(timer) { _ in
                        self.currentTime = Date()
                    }
                    .overlay(alignment:.top,content: {
                        HStack(content: {
                            ForEach(0..<5) { int in
                                Rectangle()
                                    .frame(width: 3,height: 7)
                                    .padding(.horizontal,3)
                            }
                            .offset(y:-3)
                        })
                        
                    })
                    .padding()

                }
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



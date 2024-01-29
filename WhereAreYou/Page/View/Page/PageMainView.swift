//
//  PageMainView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import SwiftUI
import Kingfisher


struct PageMainView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    @State var pageMode:PageTabFilter = .schedule
    var pageId:String
    
    @State var modifying = false
    @State var delete = false   //삭제 버튼 활성화
    @State var out = false
    @State var currentAmount:CGFloat = 0
    @State var currentDrageAmount:CGFloat = 0
    @State private var currentTime = Date()
    
    @State var isPage = false
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    
    var body: some View {
        ZStack{
            ScrollView(.vertical,showsIndicators: false){
                VStack(alignment: .leading){
                    background
                    
                    ZStack{
                        switch pageMode {
                        case .schedule:
                            SchduleListView()
                                .padding(.bottom)
                                .environmentObject(vmAuth)
                                .environmentObject(vm)
                        case .member:
                            MemberTabView()
                                .padding(.bottom)
                                .environmentObject(vmAuth)
                                .environmentObject(vm)
                        case .request:
                            RequestTabView()
                                .environmentObject(vm)
                                
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
            if let photo = vm.photo{
                Color.black.ignoresSafeArea().opacity(0.6).onTapGesture {
                    vm.photo = nil
                }
                
                KFImage(URL(string: photo))
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(1 + currentAmount)
                    .offset(y: currentDrageAmount)
                    .frame(maxHeight:.infinity)
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
            
            if isPage{
                CustomProgressView(title: "삭제 중..")
            }
            
        }
        
       
        .onAppear{
            vm.getPage(pageId: pageId)
            vm.getSchedules(pageId: pageId)
        }
        .onReceive(vm.pageDismiss) {
            vmAuth.user?.pages = vmAuth.user?.pages?.filter({$0 != vm.page?.pageId})
            vm.pages.removeAll(where: {$0 != vm.page})
            vm.page = nil
            dismiss()
        }
    }
}

struct PageMainView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PageMainView(pageId: CustomDataSet.shared.page().pageId)
                .environmentObject(PageViewModel(page: CustomDataSet.shared.page(), pages: CustomDataSet.shared.pages()))
                .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
        }
    }
}
extension PageMainView{
    
    var header:some View{
        VStack(alignment: .trailing){
            HStack{
                Button {
                    vm.page = nil
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                    
                        .padding(.leading)
                    
                }.shadow(color:.black,radius: 20)
                Spacer()
                Button {
                    vm.copyToPasteboard(text: vm.page?.pageId ?? "")
                } label: {
                    Capsule()
                        .frame(width: 90,height: 25)
                        .foregroundColor(.white)
                        .overlay {
                            Text("페이지ID 복사")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.black)
                        }
                }
                    
                Button{
                    modifying = true
                }label:{
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.white)
                        .padding(.trailing)
                }
                .confirmationDialog("일정 수정", isPresented: $modifying, actions: {
                    NavigationLink {
                        if let page = vm.page {
                            AddPageView(title: page.pageName ,text: page.pageSubscript,overseas: page.pageOverseas, startDate: page.dateRange.first?.dateValue() ?? Date(),endDate: page.dateRange.last?.dateValue() ?? Date(),pageImage: page.pageImageUrl ?? "")
                                .environmentObject(vm)
                                .environmentObject(vmAuth)
                                .navigationBarBackButtonHidden()
                        }
                    } label: {
                        Text("수정하기")
                    }
                    Button(role:.destructive){
                        if vm.page?.pageAdmin == vmAuth.user?.userId{
                            delete = true
                        }else{
                            out = true
                        }
                    } label: {
                        Text("삭제")
                    }
                })
                .confirmationDialog("", isPresented: vm.page?.pageAdmin == vmAuth.user?.userId ? $delete : $out, actions: {
                    Button(role:.destructive){
                        if vm.page?.pageAdmin == vmAuth.user?.userId{
                            guard let page = vm.page,let user = vmAuth.user else {return}
                            vm.deletePage(user:user,page: page)
                        }else{
                            if let user = vmAuth.user,let page = vm.page{
                                vm.outPage(user: user, page:page)
                            }
                        }
                    } label: {
                        Text(vm.page?.pageAdmin == vmAuth.user?.userId ? "삭제하기" : "나가기")
                    }
                },message: {
                    Text(vm.page?.pageAdmin == vmAuth.user?.userId ? "정말 이 페이지를 삭제하시겠습니까?" : "정말 이 페이지를 나가시겠습니까?")
                })
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
                                    .padding(.vertical)
                                    .bold()
                                    .overlay(alignment: .topTrailing) {
                                        if tabItem == PageTabFilter.request,vm.request.count > 0{
                                            Text("\(vm.request.count)")
                                                .font(.caption2)
                                                .foregroundStyle(.white)
                                                .padding(1)
                                                .padding(.horizontal,4)
                                                .background(Color.red)
                                                .cornerRadius(100)
                                                .offset(x:6,y:-3)
                                                
                                        }
                                    }
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
                KFImage(URL(string: vm.page?.pageImageUrl ?? "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/background%2Fnight.jpeg?alt=media&token=2191462b-14b8-4407-adcf-f73a7ed0b39e"))
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
                        if ((vm.page?.pageOverseas) != nil){        //바
                            Text("🌏")
                        }else{
                            Text("🇰🇷")
                        }
                        Text(vm.page?.pageName ?? "")
                            .font(.title)
                            .bold()
                    }
                    
                    Text(vm.page?.pageSubscript ?? "")
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



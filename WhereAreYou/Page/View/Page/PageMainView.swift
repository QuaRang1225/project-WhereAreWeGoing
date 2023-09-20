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
    var page:Page
    
//    @State var photo = false
//    @State var binding:Schedule?

    @State var currentAmount:CGFloat = 0
    @State var currentDrageAmount:CGFloat = 0
    @State private var currentTime = Date()
    
    @State var delete = false   //삭제 버튼 활성화
    @State var deletePage = false   //삭제버튼 클릭 후 삭제 중 문구
    @State var sett = false //페이지 설정 활성화
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    


    var body: some View {
        ZStack{
            ScrollView(.vertical,showsIndicators: false){
                VStack{
                    background
                    ZStack{
                        switch pageMode {
                        case .schedule:
                            SchduleListView()
                                .environmentObject(vmAuth)
                        case .member:
                            MemberTabView()
                                .environmentObject(vmAuth)
                                .environmentObject(vm)
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
            if let photo = vm.photo{
                Color.black.ignoresSafeArea().opacity(0.6).onTapGesture {
                    vm.photo = nil
                }
                
                KFImage(URL(string: photo))
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
            if deletePage{
                CustomProgressView(title: "삭제 중..")
            }
            
        }
        .onReceive(vm.deleteSuccess){
            dismiss()
        }
        .confirmationDialog("일정 수정", isPresented: $delete, actions: {
            Button(role:.destructive){
                if let user = vmAuth.user,let page = vm.page{
                    deletePage = true
                    vm.deletePage(user: user, page:page)
                }
            } label: {
                Text("삭제하기")
            }
        },message: {
            Text("정말 이 페이지를 삭제하시겠습니까?")
        })
        .onAppear{
            vm.getPage(userId: page.pageAdmin, pageId: page.pageId)
            vm.getSchedules(userId: page.pageAdmin, pageId: page.pageId)
        }
        .onDisappear{
            sett = false
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
        VStack{
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
                    VStack{
                        Button {
                            withAnimation{
                                sett.toggle()
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }
                            
                    }
            }
            if sett{
                HStack{
                    Spacer()
                    VStack{
                        NavigationLink {
                            AddPageView(title: page.pageName ,text: page.pageSubscript,overseas: page.pageOverseas, startDate: page.dateRange.first?.dateValue() ?? Date(),endDate: page.dateRange.last?.dateValue() ?? Date())
                                .environmentObject(vm)
                                .environmentObject(vmAuth)
                                .navigationBarBackButtonHidden()
                        } label: {
                            Text("수정하기")
                               
                        }.padding(.top,7.5)
                        Divider().frame(width: 100)
                        Button {
                            delete = true
                        } label: {
                            Text("삭제하기").foregroundColor(.red)
                        }
                        Divider().frame(width: 100)
                    }
                    .padding(.horizontal)
                    .font(.subheadline).foregroundColor(.black)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.trailing)
                }
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
                            .onTapGesture {
                            sett = false
                        }
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



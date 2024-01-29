//
//  RequestPageView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/09/06.
//

import SwiftUI
import Kingfisher

struct RequestPageView: View {
    
    @State var requested = false
    @State var user:UserData?
    
    @State var requestLoading = false
//    @Binding var page:Page?
//    @Binding var pages:[Page]
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    
    var body: some View {
            VStack{
                
                KFImage(URL(string: vm.page?.pageImageUrl ?? ""))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.width * (3/4))
                    .clipped()
                    .ignoresSafeArea(.all,edges: .top)
                    .overlay(alignment: .bottomTrailing) {
                        VStack{
                            KFImage(URL(string: user?.profileImageUrl ?? CustomDataSet.shared.images.first!))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60,height: 60)
                                .cornerRadius(20)
                                .overlay{
                                    Image("crown")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .offset(y:-35)
                                        .rotationEffect(Angle(degrees: 45))
                                        
                                }
                            Text("방장")
                                .font(.subheadline)
                                .padding(.top,2)
                        }
                        .offset(y:40)
                        .padding(.trailing)
                    }
                VStack(alignment: .leading){
                    HStack{
                        Text(vm.page?.pageName ?? "").bold().font(.title3)
                        Text(vm.page?.pageOverseas ?? false ? "해외여행" : "국내여행")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top,8)
                        Spacer()
                        
                        
                    }
                    VStack(alignment: .leading){
                        Text("시작 : \(vm.page?.dateRange.first?.dateValue().toString() ?? "")")
                        Text("끝 : \(vm.page?.dateRange.last?.dateValue().toString() ?? "")")
                    }.padding(.bottom)
                    Text("내용").padding(.bottom,1).bold()
                    Text(vm.page?.pageSubscript ?? "")
                        .lineLimit(2)
                        .padding(.bottom,50)
                }.padding(.horizontal)
                
               
                Spacer()
                if let pageMembers = vm.page?.members, !pageMembers.contains(vmAuth.user?.userId ?? ""){
                    SelectButton(color: requested ? Color.gray.opacity(0.6) :  Color.customCyan2.opacity(0.7), textColor: .white, text: requested ? "요청 취소" : "요청"){
                        requested = true
                        guard let user = vmAuth.user,let pageid = vm.page?.pageId else {return}
                        requestLoading = true
                        vm.requestPage(user:user,pageId:pageid,cancel:requested)
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
            .foregroundColor(.black)
            .overlay{
                if requestLoading{
                    CustomProgressView(title: "초대 요청 중")
                }
            }
        
        .onAppear{
            Task{
                //방장 화면
                self.user = try await UserManager.shared.getUser(userId: vm.page?.pageAdmin ?? "")
            }
            
            if let request = vm.page?.request,let user = vmAuth.user?.userId, request.contains(user){
                self.requested = true
            }
            else {
                self.requested = false
            }
        }
        .onDisappear{
            vm.page = nil
        }
        .onReceive(vm.requsetDismiss) { page in
            if let oldPage = vm.page,let index = vm.pages.firstIndex(of: oldPage){
                vm.pages[index] = page
                requestLoading = false
            }
            
        }
        
    }
}

struct RequestPageView_Previews: PreviewProvider {
    static var previews: some View {
        RequestPageView()
            .environmentObject(PageViewModel(page: CustomDataSet.shared.page(), pages: CustomDataSet.shared.pages()))
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}

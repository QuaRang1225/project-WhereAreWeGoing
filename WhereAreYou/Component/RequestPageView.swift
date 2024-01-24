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
    @Binding var page:Page?
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading){
                
                KFImage(URL(string: page?.pageImageUrl ?? ""))
                    .resizable(resizingMode: .tile)
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .overlay{
                        ZStack(alignment:.topTrailing){
                            Color.black.opacity(0.2)
                            Button {
                                page = nil
                            } label: {
                                Image(systemName: "xmark")
                                     .padding()
                                     .foregroundColor(.white)
                                     .bold()
                                     .font(.title3)
                            }
                        }
                    }
                
                HStack{
                    Text(page?.pageName ?? "").bold().font(.title3)
                    Text(page?.pageOverseas ?? false ? "해외여행" : "국내여행")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top,8)
                    Spacer()
                    
                    
                    KFImage(URL(string: user?.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60,height: 60)
                        .cornerRadius(20)
                        .overlay(alignment:.topTrailing){
                            Image("crown")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .offset(y:-15)
                                .rotationEffect(Angle(degrees: 45))
                        }
                        .offset(y:-40)
                        .overlay{
                            Text("방장")
                                .font(.subheadline)
                                .padding(.top,2)
                        }
                        .padding(.trailing)
                }.padding(.leading).frame(height: 40)
                VStack(alignment: .leading){
                    Text("시작 : \(page?.dateRange.first?.dateValue().toString() ?? "")")
                    Text("끝 : \(page?.dateRange.last?.dateValue().toString() ?? "")")
                }.padding([.bottom,.leading])
                Text("내용").padding(.leading).padding(.bottom,1).bold()
                Text(page?.pageSubscript ?? "")
                    .padding(.horizontal)
                    .padding(.bottom,50)
                
            }
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            if let pageMembers = page?.members, !pageMembers.contains(vmAuth.user?.userId ?? ""){
                Button {
                    requested.toggle()
                    guard let user = vmAuth.user,let pageid = page?.pageId else {return}
                    vm.requestPage(user:user,pageId:pageid,cancel:requested)
                } label: {
                    Text(requested ? "요청됨" : "요청")
                        .padding(.horizontal).padding(5)
                        .background(requested ? Color.gray.opacity(0.6) :  Color.customCyan2.opacity(0.7))
                        .foregroundColor(.white)
                        .bold()
                        .cornerRadius(10)
                        .padding()
                }
            }
            
        }
        .onAppear{
            Task{
                self.user = try await UserManager.shared.getUser(userId: page?.pageAdmin ?? "")
            }
            
            if let request = page?.request,let user = vmAuth.user?.userId, request.contains(user){
                self.requested = true
            }
            else {
                self.requested = false
            }
        }
    }
}

struct RequestPageView_Previews: PreviewProvider {
    static var previews: some View {
        RequestPageView(page: .constant(CustomDataSet.shared.page()))
            .environmentObject(PageViewModel(page: nil, pages: CustomDataSet.shared.pages()))
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}

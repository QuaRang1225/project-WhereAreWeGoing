//
//  MemberTabView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI
import Kingfisher

struct MemberTabView: View {
    
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var vm:PageViewModel
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            Section("방장"){
                MemberListRowView(image: vm.admin?.profileImageUrl ?? "", name: vm.admin?.nickName ?? "",admin: true)
            }
            .padding(.vertical)
            Divider()
            Section("맴버"){
                if vm.member.isEmpty{
                    emptymember
                }else{
                    ForEach(vm.member,id:\.self){ member in
                        MemberListRowView(image: member.profileImageUrl ?? "", name: member.nickName ?? "",admin: false)
                    }
                }
            }
            .padding(.vertical)
            Section("초대 요청"){
                if vm.request.isEmpty{
                    emptyrequest
                }else{
                    ForEach(vm.request,id:\.self) { request in
                        MemberListRowView(image: request.profileImageUrl ?? "", name: request.nickName ?? "",admin: false)
                            .overlay(alignment:.trailing){
                                Button {
                                    if let user = vmAuth.user,let page = vm.page{
                                        vm.userAccept(user: user, page:page, requestUser: request)
                                    }
                                } label: {
                                    Text("수락")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                        .padding(5)
                                        .background(Color.customCyan2.opacity(0.7))
                                        .cornerRadius(20)
                                }
                            }
                    }
                }
            }
            .padding(.vertical)
        }
        .padding()
//        .onReceive(vm.succenss){
//            if let page = vm.page{
//                vm.getMembers(page: page)
//            }
//        }
        .onAppear{
            if let page = vm.page{
                Task{
                    vm.admin =  try await UserManager.shared.getUser(userId: page.pageAdmin)
                    vm.getMembers(page: page)
                }
            }
        }
        .onDisappear{
            vm.request.removeAll()
            vm.member.removeAll()
        }
    }
    
}

struct MemberTabView_Previews: PreviewProvider {
    static var previews: some View {

        MemberTabView()
            .environmentObject(PageViewModel())
            .environmentObject(AuthViewModel())
          
    }
}

extension MemberTabView{
    var emptymember:some View{
        HStack{
            Image(systemName: "person.fill.xmark")
            Text("아직 맴버가 없습니다.")
        }
        .foregroundColor(.gray.opacity(0.5))
    }
    var emptyrequest:some View{
        HStack{
            Image(systemName: "bell.badge.fill")
            Text("요청이 존재하지 않습니다.")
        }
        .foregroundColor(.gray.opacity(0.5))
    }
}



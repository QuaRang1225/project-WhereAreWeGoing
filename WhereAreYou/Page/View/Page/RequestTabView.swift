//
//  RequestTabView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 1/26/24.
//

import SwiftUI

struct RequestTabView: View {
    @EnvironmentObject var vm:PageViewModel
    var body: some View {
        VStack(alignment: .leading){
            Section("초대 요청"){
                if vm.request.isEmpty{
                    emptyrequest
                }else{
                    ForEach(vm.request,id:\.self) { request in
                        MemberListRowView(image: request.profileImageUrl ?? "", name: request.nickName ?? "",admin: false)
                            .overlay(alignment:.trailing){
                                Button {
                                    guard let page = vm.page else {return}
                                    vm.userAccept(page: page, requestUser: request)
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
        }
        .padding(.horizontal)
        .padding(.vertical)
    }
    var emptyrequest:some View{
        HStack{
            Image(systemName: "bell.badge.fill")
            Text("요청이 존재하지 않습니다.")
        }
        .padding(.vertical)
        .foregroundColor(.gray.opacity(0.5))
    }
}

#Preview {
    RequestTabView()
        .environmentObject(PageViewModel(page: nil, pages: []))
}

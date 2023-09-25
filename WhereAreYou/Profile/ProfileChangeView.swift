//
//  ProfileChangeView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/09/25.
//

import SwiftUI

struct ProfileChangeView: View {
    
    @State var user:UserData
    @State var profile = false
    @State var nickname = false
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var vmAuth:AuthViewModel
    var body: some View {
        VStack{
            ZStack(alignment: .leading){
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Text("프로필 변경").font(.title3).frame(maxWidth: .infinity).bold()
            }.padding(.bottom)
            ScrollView{
                VStack(alignment: .leading) {
                    Button {
                        profile = true
                    } label: {
                        Text("프로필 사진 변경")
                    }
                    Divider()
                    Button {
                       nickname = true
                    } label: {
                        Text("닉네임 변경")
                    }
                    Divider()
                    Text("로그아웃")
                        .foregroundColor(.red)
                    Divider()
                    Text("탈퇴하기")
                        .foregroundColor(.red)
                    Divider()
                }
                
            }
            
        }
        .foregroundColor(.black)
        .padding()
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $nickname){
            NickNameView(text: user.nickName ?? "",modify: true)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }
        .sheet(isPresented: $profile) {
            ProfileSelectView(modify: true)
            .environmentObject(vmAuth)
            .navigationBarBackButtonHidden()
        }
    }
}

//struct ProfileChangeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileChangeView(user: UserData)
//            .environmentObject(AuthViewModel())
//    }
//}

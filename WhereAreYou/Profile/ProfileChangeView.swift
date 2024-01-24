//
//  ProfileChangeView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/09/25.
//

import SwiftUI

struct ProfileChangeView: View {
    

    @State var profile = false
    @State var nickname = false
    
    @State var logout = false
    @State var delete = false
    
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
                    Button {
                        logout = true
                    } label: {
                        Text("로그아웃")
                            .foregroundColor(.red)
                    }
                    Divider()
                    Button {
                        delete = true
                    } label: {
                        Text("탈퇴하기")
                            .foregroundColor(.red)
                    }
                    Divider()
                }
            }
        }
        .foregroundColor(.black)
        .padding()
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $nickname){
            NickNameView(text: vmAuth.user?.nickName ?? "",modify: true)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }
        .sheet(isPresented: $profile) {
//            ProfileSelectView(modify: true)
//            .environmentObject(vmAuth)
//            .navigationBarBackButtonHidden()
        }
        .confirmationDialog("로그아웃", isPresented: $logout, actions: {
            Button(role:.destructive){
                vmAuth.logOut()
            } label: {
                Text("로그아웃")
            }
        },message: {
            Text("정말 로그아웃 하시겠습니까?")
        })
        .confirmationDialog("계정 탈퇴", isPresented: $delete, actions: {
            Button(role:.destructive){
                guard let user = vmAuth.user else {return}
                vmAuth.delete(user: user)
                vmAuth.user = nil
            } label: {
                Text("탈퇴하기")
            }
        },message: {
            Text("정말 탈퇴 하시겠습니까?")
        })
    }
}

struct ProfileChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileChangeView()
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}

//
//  NickNameView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct NickNameView: View {
    @State var text = ""
    @State var isProfile = false
    @Binding var isLogin:Bool
    @EnvironmentObject var vm:AuthViewModel
    var body: some View {
        VStack{
            Text("닉네임설정")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading)
                .padding(.bottom,30)
            ScrollView {
                CustomTextField(placeholder: "입력..", isSecure: false, text: $text)
                    .padding(.top,50)
                Text("닉네임을 설정하지 않을 시 이메일로 자동설정 되며. 이후에 변경할 수 있습니다.")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding(.bottom)
                SelectButton(color: .customYellow, textColor: .white, text: "확인") {
                     
                }
                Button {
                    
                } label: {
                    Text("건너뛰기")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
        .background{
            AuthBackground()
        }
        .navigationDestination(isPresented: $isProfile) {
            ProfileSelectView(isNickname: $isLogin)
                .environmentObject(vm)
        }
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
        NickNameView(isLogin: .constant(true))
            .environmentObject(AuthViewModel())
    }
}

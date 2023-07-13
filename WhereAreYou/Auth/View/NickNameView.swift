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
    @EnvironmentObject var vm:AuthViewModel
    var body: some View {
        VStack{
            Text("닉네임설정")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading)
                .padding(.bottom,30)
                .foregroundColor(.black)
            ScrollView {
                CustomTextField(placeholder: "입력..", isSecure: false, text: $text)
                    .padding(.top,50)
                Text("닉네임을 설정하지 않을 시 이메일로 자동설정 되며. 이후에 변경할 수 있습니다.")
                    .foregroundColor(.gray)
                    .font(.caption)
                    .padding(.bottom)
                SelectButton(color: .customYellow, textColor: .white, text: "확인") {
                    withAnimation(.linear){
                        vm.user?.nickName = text
                        vm.infoSetting = InfoSettingFilter.profile
                    }
                }
                Button {
                    withAnimation(.linear){
                        vm.user?.nickName = "으딩이\(Range(1...10).randomElement() ?? 1)"
                        vm.infoSetting = InfoSettingFilter.profile
                    }
                } label: {
                    Text("건너뛰기")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
            }
        }
       
        .navigationDestination(isPresented: $isProfile) {
            ProfileSelectView()
                .environmentObject(vm)
        }
        .onTapGesture { //이거 넣으면 탭뷰 터치 안됨
            UIApplication.shared.endEditing()
        }
        .onDisappear{
            UIApplication.shared.endEditing()
        }
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
        NickNameView()
            .environmentObject(AuthViewModel())
    }
}

//
//  NickNameView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct NickNameView: View {
    @State var text = ""
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
                SelectButton(color: .customYellow, textColor: .white, text: "확인") {
                     
                }
            }
        }
        .background{
            AuthBackground()
        }
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
        NickNameView()
    }
}

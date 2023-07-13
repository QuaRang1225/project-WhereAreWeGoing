//
//  SearchView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/11.
//

import SwiftUI

struct SearchView: View {
    @State var text = ""
    var body: some View {
        ZStack{
            ScrollView{
                VStack{
                    Text("친구검색")
                        .foregroundColor(.black)
                        .padding(.bottom)
                        .bold()
                    CustomTextField(placeholder: "친구의 가입 이메일을 입력해주세요..", isSecure: false, text: $text)
                    Spacer()
                    SelectButton(color: !text.isEmpty ? .customYellow:.gray.opacity(0.5), textColor:.white, text: "검색") {
                        text = "yuyw99@gmail.com"
                        Task{
                            try? await UserManager.shared.getSearchUser(email: text)
                        }
                    }
                }
            }
        }
        .background{
            Color.white.ignoresSafeArea()
            AuthBackground()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

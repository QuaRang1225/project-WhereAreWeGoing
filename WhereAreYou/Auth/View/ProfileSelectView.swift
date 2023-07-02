//
//  ProfileSelectView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import PhotosUI

struct ProfileSelectView: View {
    var body: some View {
        VStack{
            Text("프로필선택")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading)
                .padding(.bottom,30)
            ScrollView {
                CustomPhotoPicker()
                    .padding(.vertical,50)
                SelectButton(color: .customYellow, textColor: .white, text: "확인") {
                     
                }
            }
        }
        .background {
            AuthBackground()
        }
    }
}

struct ProfileSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectView()
    }
}

//
//  ProfileSelectView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import PhotosUI

struct ProfileSelectView: View {
    
    @Binding var isNickname:Bool
    @EnvironmentObject var vm:AuthViewModel
    
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
                Button {
                    
                } label: {
                    Text("건너뛰기")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()

            }
        }
        .background {
            AuthBackground()
        }
    }
}

struct ProfileSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectView(isNickname: .constant(true))
            .environmentObject(AuthViewModel())
    }
}

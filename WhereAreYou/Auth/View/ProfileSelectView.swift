//
//  ProfileSelectView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import PhotosUI

struct ProfileSelectView: View {
    
    @EnvironmentObject var vm:AuthViewModel
    @State var create = false //계정 만드는 중..
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                Text("프로필선택")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.leading)
                    .padding(.bottom,30)
                    .foregroundColor(.black)
                ScrollView {
                    CustomPhotoPicker()
                        .padding(.vertical,50)
                    SelectButton(color: .customCyan, textColor: .white, text: "확인") {
                        create = true
                        guard let item = vm.selectedItem else {return}
                        vm.saveProfileImage(item: item)
                        
                    }
                    Button {
                        create = true
                        Task{
                            guard var user = vm.user else {return}
                            user.guestMode = false
                            user.profileImageUrl = CustomDataSet.shared.images.randomElement()
                            try UserManager.shared.createNewUser(user: user)
                            vm.user?.guestMode = false
                        }
                    } label: {
                        Text("건너뛰기")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()

                }
            }
            if create{
                CustomProgressView(title: "계정 생성 중..").ignoresSafeArea()
            }
        }
        
    }
}

struct ProfileSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectView()
            .environmentObject(AuthViewModel())
    }
}

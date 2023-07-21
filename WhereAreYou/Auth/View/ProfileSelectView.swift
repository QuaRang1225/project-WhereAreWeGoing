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
    
    var body: some View {
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
                    if let item = vm.selectedItem{
                        vm.user?.guestMode = false
                        vm.saveProfileImage(item: item)
                        Task{
                            try UserManager.shared.createNewUser(user: vm.user!)
                        }
                    }
                }
                Button {
                    vm.user?.profileImageUrl = CustomDataSet.shared.images.randomElement()
                    vm.user?.guestMode = false
                    Task{
                        try UserManager.shared.createNewUser(user: vm.user!)
                    }
                    
                } label: {
                    Text("건너뛰기")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()

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

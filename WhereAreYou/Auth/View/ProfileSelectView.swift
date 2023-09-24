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
    @State var modify = false
    @State var create = false //계정 만드는 중..
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                Text(modify ? "프로필수정" : "프로필선택")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.leading)
                    .padding(.vertical,30)
                    .foregroundColor(.black)
                ScrollView {
                    CustomPhotoPicker()
                        .padding(.vertical,50)
                    SelectButton(color: .customCyan, textColor: .white, text: "확인") {
                        create = true
                        guard let item = vm.selectedItem else { return vm.noImageSave() }
                        if !modify{
                            vm.saveProfileImage(item: item)
                        }else{
                            vm.updateProfileImage(item: item)
                        }
                    }
                    if !modify{
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
            }
            if create{
                CustomProgressView(title: "계정 생성 중..").ignoresSafeArea()
            }
        }
        .onDisappear{
            vm.selectedItem = nil
            vm.selectedImageData = nil
        }
        .onReceive(vm.changedSuccess){
            dismiss()
        }
        
    }
}

struct ProfileSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSelectView()
            .environmentObject(AuthViewModel())
    }
}

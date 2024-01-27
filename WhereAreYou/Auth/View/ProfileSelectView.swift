//
//  ProfileSelectView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileSelectView: View {
    
    @State var profile = ""
    @EnvironmentObject var vm:AuthViewModel
    @State var create = false //계정 만드는 중..
    @Environment(\.dismiss) var dismiss
    
    let columns: [GridItem] = [
            GridItem(.fixed(100), spacing: nil, alignment: nil),
            GridItem(.fixed(100), spacing: nil, alignment: nil),
            GridItem(.fixed(100), spacing: nil, alignment: nil)
            
        ]
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                Text("프로필선택")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding(.leading)
                    .padding(.vertical,30)
                    .foregroundColor(.black)
                ScrollView {
                    
                    LazyVGrid(columns: columns,spacing: 20){
                        ForEach(CustomDataSet.shared.images,id:\.self){ image in
                            Button {
                                vm.selectedImageData = nil
                                vm.selectedItem = nil
                                profile = image
                            } label: {
                                KFImage(URL(string:image))
                                    .resizable()
                                    .overlay{
                                        if !profile.isEmpty || vm.selectedItem != nil{
                                            if vm.selectedItem != nil || profile != image{
                                                Color.white.opacity(0.8)
                                            }
                                        }
                                    }
                                    .frame(width: 80,height: 80)
                                    .cornerRadius(30)
                            }
                        }
                        PhotosPicker(
                            selection: $vm.selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                if let selectedImageData = vm.selectedImageData,
                                   let uiImage = UIImage(data: selectedImageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80,height: 80).clipShape(RoundedRectangle(cornerRadius: 30))
                                    
                                }else{
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(lineWidth: 1)
                                        .frame(width: 80,height: 80)
                                        .overlay {
                                            Image(systemName: "camera")
                                                .font(.title)
                                        }
                                        .foregroundStyle(.gray)
                                }
                            }
                            .onChange(of: vm.selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        vm.selectedImageData = data
                                    }
                                }
                            }
                        
                    }
                    .foregroundColor(.black)
                    .padding(.bottom,30)
                    
                    SelectButton(color:vm.selectedItem != nil || !profile.isEmpty ? .customCyan3 : .gray, textColor: .white, text: "확인") {
                        if let item = vm.selectedItem {
                            create = true
                                vm.savePhotoProfileImage(item: item)
                        }else if !profile.isEmpty,profile != "photo" {
                            create = true
                            vm.saveImageProfileImage(item: profile)
                        }
                        
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
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}

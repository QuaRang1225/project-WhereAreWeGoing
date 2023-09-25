//
//  CustomPhotoPicker.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct CustomPhotoPicker: View {
    
    @State var profile:String? = nil
    @EnvironmentObject var vm:AuthViewModel
    var body: some View {
        PhotosPicker(
            selection: $vm.selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                if let selectedImageData = vm.selectedImageData,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                }else{
                    if vm.user?.profileImagePath != nil{
                        if let profile{
                            KFImage(URL(string: profile))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        }else{
                            empty
                        }
                    }else{
                        empty
                    }
                    
                    
                }
            }
            .overlay(alignment:.topTrailing){
                
                if vm.selectedImageData != nil || profile != nil{
                    Button {
                        vm.selectedItem = nil
                        vm.selectedImageData = nil
                        profile = nil
                    } label: {
                        Image(systemName: "xmark")
                            .padding(7)
                            .foregroundColor(.white)
                            .background(Color.gray)
                            .clipShape(Circle())
                        
                    }
                    .padding([.top,.trailing])
                }
            }.onChange(of: vm.selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        vm.selectedImageData = data
                        
                    }
                }
            }
            .onAppear{
                if vm.user?.profileImagePath != nil{
                    profile = vm.user?.profileImageUrl
                }
                
            }
        
    }
}

struct CustomPhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPhotoPicker()
            .environmentObject(AuthViewModel())
    }
}

extension CustomPhotoPicker{
    var empty:some View{
        Circle()
            .stroke(lineWidth: 5)
            .frame(width: 200, height: 200)
            .overlay {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50,height: 50)
            }
            .foregroundColor(.customCyan)
    }
}

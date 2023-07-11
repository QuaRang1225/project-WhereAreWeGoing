//
//  CustomPhotoPicker.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import PhotosUI

struct CustomPhotoPicker: View {
    
    
    
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
                       Circle()
                           .stroke(lineWidth: 5)
                           .frame(width: 200, height: 200)
                           .overlay {
                               Image(systemName: "camera")
                                   .resizable()
                                   .scaledToFill()
                                   .frame(width: 50,height: 50)
                           }
                           .foregroundColor(.customYellow)
                   }
               }.onChange(of: vm.selectedItem) { newItem in
                   Task {
                       if let data = try? await newItem?.loadTransferable(type: Data.self) {
                           vm.selectedImageData = data
                       }
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

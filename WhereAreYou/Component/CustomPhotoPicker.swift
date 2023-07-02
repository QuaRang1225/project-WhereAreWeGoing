//
//  CustomPhotoPicker.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import PhotosUI

struct CustomPhotoPicker: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    var body: some View {
        PhotosPicker(
               selection: $selectedItem,
               matching: .images,
               photoLibrary: .shared()) {
                   if let selectedImageData,
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
               }.onChange(of: selectedItem) { newItem in
                   Task {
                       // Retrive selected asset in the form of Data
                       if let data = try? await newItem?.loadTransferable(type: Data.self) {
                           selectedImageData = data
                       }
                   }
               }
    }
}

struct CustomPhotoPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomPhotoPicker()
    }
}

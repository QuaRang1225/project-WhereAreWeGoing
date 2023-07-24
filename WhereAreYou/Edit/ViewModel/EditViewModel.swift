//
//  EditViewModel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/22.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase

@MainActor
class EditViewModel:ObservableObject{
    @Published var data:Data? = nil
    @Published var selection:PhotosPickerItem? = nil
    
    func saveProfileImage(user:UserData){
        
        Task{
            guard let data = try await selection?.loadTransferable(type: Data.self) else {return}
           
            let (path,_) = try await StorageManager.shared.saveImage(data:data,userId: user.userId)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateUserPageImagePath(userId: user.userId, path: path,url: url.absoluteString)
        }
    }
}


struct Page:Codable{
    
}

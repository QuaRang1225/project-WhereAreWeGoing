//
//  AuthViewModel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/08.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
final class AuthViewModel:ObservableObject{
    
    @Published var user:UserData? = nil
    @Published var infoSetting:InfoSettingFilter = .nickname
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    
    func signUp(email:String,password:String) async throws{
        let authUser = try await AuthManager.shared.createUser(email: email, password: password) //값을 굳이 안쓰고 컴파일러에 값이 있을
        user = UserData(auth: authUser)
        try UserManager.shared.createNewUser(user: user!)
        print("가입 성공")
    }
    func signIn(email:String,password:String) async throws{
        let authUser = try await AuthManager.shared.signInUser(email: email, password: password) //값을 굳이 안쓰고 컴파일러에 값이 있을
        print(authUser)
        user = try await UserManager.shared.getUser(userId: authUser.uid)
        print("인증 성공")
    }
    func saveProfileImage(item:PhotosPickerItem){
        guard let user else {return}
        
        Task{
            guard let data = try await item.loadTransferable(type: Data.self) else {return}
           
            let (path,name) = try await StorageManager.shared.saveImage(data:data,userId: user.userId)
            print(path)
            print(name)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path,url: url.absoluteString)
        }
    }
    func deleteProfileImage(){
        guard let user,let path = user.profileImageUrl else {return}
        
        Task{
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil, url: nil)
        }
    }
}

//
//  AuthViewModel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/08.
//

import Foundation
import PhotosUI
import SwiftUI
import Combine

@MainActor
final class AuthViewModel:ObservableObject{
    
    @Published var errorString:String = ""
    
    @Published var user:UserData? = nil
    @Published var infoSetting:InfoSettingFilter = .nickname
    @Published var selectedItem: PhotosPickerItem? = nil
    @Published var selectedImageData: Data? = nil
    
    var changedSuccess = PassthroughSubject<(),Never>()
    var deleteSuccess = PassthroughSubject<(),Never>()
    
    func signUp(email:String,password:String) async throws{
        do{
            let authUser = try await AuthManager.shared.createUser(email: email, password: password) //값을 굳이 안쓰고 컴파일러에 값이 있을
            user = UserData(auth: authUser)
            try UserManager.shared.createNewUser(user: user!)
            print("가입 성공")
        }catch{
            switch error.localizedDescription{
            case "The password must be 6 characters long or more.":
                return errorString = "비밀번호는 최소 6자 이상으로 해주세요!"
            case "The email address is already in use by another account.":
                return errorString = "이미 존재하는 이메일입니다!"
            default:
                return print("에러 발생: \(error.localizedDescription)")
            }
        }
    }
    func signIn(email: String, password: String) async throws {
        do {
            let authUser = try await AuthManager.shared.signInUser(email: email, password: password)
            user = try await UserManager.shared.getUser(userId: authUser.uid)
            print("인증 성공")
        } catch {
            switch error.localizedDescription{
            case "There is no user record corresponding to this identifier. The user may have been deleted.":
                return errorString = "사용자를 찾을 수 없습니다. 이메일 혹은 비밀번호를 확인해주세요!"
            default:
                return print("에러 발생: \(error.localizedDescription)")
            }
        }
    }
    func updateNickname(userId:String,text:String){
        Task{
            try await UserManager.shared.updateUsetNickname(userId:userId,text:text)
            self.user = try await UserManager.shared.getUser(userId: userId)
            changedSuccess.send()
        }
    }
    func saveProfileImage(item:PhotosPickerItem){
        guard var user else {return}
        
        Task{
            guard let data = try await item.loadTransferable(type: Data.self) else {return}
           
            let path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .profile)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            user.guestMode = false
            try UserManager.shared.createNewUser(user: user)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path,url: url.absoluteString)
            
            self.user = try await UserManager.shared.getUser(userId: user.userId)
        }
    }
    func deleteProfileImage(){
        guard let user,let path = user.profileImagePath else {return}
        
        Task{
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil, url: nil)
            self.user = try await UserManager.shared.getUser(userId: user.userId)
            changedSuccess.send()
        }
    }
    func updateProfileImage(item:PhotosPickerItem){
        guard let user else {return}
        Task{
            
            if let path = user.profileImagePath{
                try await StorageManager.shared.deleteImage(path: path)
            }
            
            guard let data = try await item.loadTransferable(type: Data.self) else {return}
            let path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .profile)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: path,url: url.absoluteString)
            
           
            self.user = try await UserManager.shared.getUser(userId: user.userId)
            changedSuccess.send()
        }
    }
    func noImageSave(){
        Task{
            guard let user,let path = user.profileImagePath else {return}
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImagePath(userId: user.userId, path: nil,url:CustomDataSet.shared.images.randomElement())
            self.user = try await UserManager.shared.getUser(userId: user.userId)
            changedSuccess.send()
        }
    }
    
    
    func logOut(){
        try? AuthManager.shared.signOut()
        user = nil
    }
    func delete(user:UserData){
        Task{
            try await AuthManager.shared.delete()   //유저 정보 삭제
            try await StorageManager.shared.deleteAllPageImage(path: "\(user.userId)")  //본인의 페이지 사진 모두 삭제
            try await StorageManager.shared.deleteAllScheuleImage(path: "\(user.userId)")   //본인의 스케쥴 사진 모두 삭제
            try await UserManager.shared.deleteUser(user: user)
            
        }
    }
    func getUser(auth:AuthData){
        Task{
            user = try await UserManager.shared.getUser(userId: auth.uid)
        }
    }
}

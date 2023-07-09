//
//  AuthViewModel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/08.
//

import Foundation

@MainActor
final class AuthViewModel:ObservableObject{
    
    @Published var user:UserData? = nil
    @Published var aa = false
    
    func signUp(email:String,password:String) async throws{
        let authUser = try await AuthManager.shared.createUser(email: email, password: password) //값을 굳이 안쓰고 컴파일러에 값이 있을
        user = UserData(auth: authUser)
        try UserManager.shared.createNewUser(user: user!)
        print("가입 성공")
    }
    func signIn(email:String,password:String) async throws{
        let authUser = try await AuthManager.shared.signInUser(email: email, password: password) //값을 굳이 안쓰고 컴파일러에 값이 있을
        user = UserData(auth: authUser)
        print("인증 성공")
    }
}

//
//  AuthManager.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/08.
//

import Foundation
import FirebaseAuth

final class AuthManager{
    
    static let shared = AuthManager()   //싱글톤
    private init(){}
    
    @discardableResult //리턴값을 사용하지 않아도 warning이 나오지 않도록 설정할 수 있음
    func createUser(email:String,password:String) async throws-> AuthData{
        let authDataResult = try await Auth.auth().createUser(withEmail:email,password:password)
        return AuthData(user: authDataResult.user) //authDataResult.user - 유저정보(email,password,프로필이미지)
    }
    
    @discardableResult
    func signInUser(email:String,password:String) async throws-> AuthData{
        let authDataResult = try await Auth.auth().signIn(withEmail:email,password:password)
        return AuthData(user: authDataResult.user) //authDataResult.user - 유저정보(email,password,프로필이미지)
    }
    
    func getUser() throws -> AuthData{        //데이터를 가져오는것이 아니고 그냥 값을 확인할 경우에는 비동기 이벤트일 필요가 없기 때문에 async를 사용하지 않음(서버로 도달하지 않고 (fireSDK)로컬에서 데이터를 구분함)
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        return AuthData(user: user)
    }

    func updatePassword(password:String)async throws{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        try await user.updatePassword(to: password)
    }
    
    func updateEmail(email:String)async throws{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        try await user.updateEmail(to: email)
    }
    
    func signOut() throws{
        try Auth.auth().signOut()
    }
    
    func delete() async throws{
        guard let user = Auth.auth().currentUser else{
            throw URLError(.badServerResponse)
        }
        try await user.delete()
    }
}

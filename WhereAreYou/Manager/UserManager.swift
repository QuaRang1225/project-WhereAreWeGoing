//
//  UserManager.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/09.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager{
    
    static let shared = UserManager()
    private init(){}
    
    private let userCollection = Firestore.firestore().collection("users")  //경로 설정
    
    private func userDocument(userId:String) -> DocumentReference{
        userCollection.document(userId)
    }
    
    //snakeCase적용 위함
    private let encoder:Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase   //ex) dateCreadted -> datae_created
        return encoder
    }()
    private let decoder:Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase //datae_created -> dateCreadted
        return decoder
    }()
    
    func createNewUser(user:UserData) throws{   //DB에 저장
        try userDocument(userId: user.userId).setData(from: user,merge: false,encoder: encoder)
    }
    func updateUserProfileImagePath(userId:String,path:String?,url:String?)async throws{
        let data:[String:Any] = ["profile_image_url":url]
        print(data)
        try await userDocument(userId:userId).updateData(data)
    }
    func getUser(userId:String) async throws -> UserData{
        try await userDocument(userId: userId).getDocument(as: UserData.self,decoder: decoder)
    }
    
}

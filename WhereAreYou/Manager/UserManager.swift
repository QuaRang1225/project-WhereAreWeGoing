//
//  UserManager.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/09.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


final class UserManager{
    
    static let shared = UserManager()
    private init(){}
    
    private let pagesCollection = Firestore.firestore().collection("pages")
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
        let data:[String:Any] = [
            "profile_image_url":url as Any,
            "profile_image_path":path as Any
        ]
        try await userDocument(userId:userId).updateData(data)
    }
    func updateUsetNickname(userId:String,text:String)async throws{
        let data:[String:Any] = [
            "nick_name":text as Any
        ]
        try await userDocument(userId:userId).updateData(data)
    }
    
    
    func getUser(userId:String) async throws -> UserData{
        try await userDocument(userId: userId).getDocument(as: UserData.self,decoder: decoder)
    }
    
    
    func getSearchUser(email:String) async throws{
        let querySnapshot = try await userCollection.whereField("email", isEqualTo: email).getDocuments()
        
        for document in querySnapshot.documents {
            print("\(document.documentID) => \(document.data())")
            
            let data = document.data()
            var convertedData = data
            
            if let timestamp = data["date_created"] as? Timestamp {
                convertedData["date_created"] = "\(timestamp.dateValue())"
            }
            
            if let user = try? JSONDecoder().decode(UserData.self,fromJSONObject: convertedData){
                print(user)
            }
        }
    }
    func updatePages(userId:String,pagesId:String) async throws{
        let data:[String:Any] = ["pages":FieldValue.arrayUnion([pagesId])]
        print("유저정보에 페이지 정보저장")
        try await userDocument(userId: userId).updateData(data)
    }
    
    func getSearchPage(text:String)async throws -> [Page]{
        
        let pages = try await pagesCollection.getAllDocuments(as: Page.self)
        let search = pages.filter({$0.pageName.contains(text) || $0.pageId.contains(text)})
        return search
        
    }
    func deleteUser(user:UserData)async throws{
        guard let pages = user.pages else {return}
        print("계정삭제 중")
        
        try await userDocument(userId: user.userId).delete()    //본인 정보 삭제
        try await StorageManager.shared.deleteImage(path: user.profileImagePath ?? "")  //본인 프로필 사진 삭제

        for page in pages{
            try await PageManager.shared.deleteUserPage(pageId: page)   //본인의 페이지 모두 삭제
            try await PageManager.shared.memberPage(userId: user.userId, pageId: page, cancel: true) //본인이 속한 페이지에서 본인 정보 모두 삭제
        }
    }
}

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
    
    private let userCollection = Firestore.firestore().collection("users")  //경로 설정
    
    private func userDocument(userId:String) -> DocumentReference{
        userCollection.document(userId)
    }
    private func userPageDocumentCollection(userId:String) -> CollectionReference{
        userDocument(userId:userId).collection("page")
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
        try await userDocument(userId:userId).updateData(data)
    }
    func createUserPage(userId:String,url:String,pageInfo:PageInfo)async throws{
        let document = userPageDocumentCollection(userId: userId).document()
        let documentId = document.documentID
                
        let data:[String:Any] = [
            "page_id":documentId,
            "page_admin":userId,
            "page_image_url":url,
            "page_name":pageInfo.pageName,
            "page_subscript":pageInfo.pageSubscript,
            "page_overseas":pageInfo.overseas,
            "date_range":pageInfo.dateRange,
            
        ]
        try await document.setData(data,merge: false)
        
    }
    
    func getUser(userId:String) async throws -> UserData{
        try await userDocument(userId: userId).getDocument(as: UserData.self,decoder: decoder)
    }
    func getAllUserFavoriteProduct(userId:String)async throws -> [Page]{    //전체페이지 불러오기
        try await userPageDocumentCollection(userId: userId).getDocuments2(as: Page.self)
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
    
}

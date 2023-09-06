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
        let data:[String:Any] = ["profile_image_url":url as Any]
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
    
    func getSearchPage(text:String)async throws -> [Page]{
        
        var pages:[Page] = []
        let snapshot = try await userCollection.getDocuments()
        for userDocument in snapshot.documents{
            let pagesCollection = try await userDocument.reference.collection("page").getDocuments()
            for pageDocument in pagesCollection.documents{
                    if let name = pageDocument.get("page_name") as? String,name.contains(text){
                        let page = try await pageDocument.reference.getDocument(as: Page.self)
                        pages.append(page)
                    }
                    if let id = pageDocument.get("page_id") as? String,id.contains(text){
                        let page = try await pageDocument.reference.getDocument(as: Page.self)
                        pages.append(page)
                    }
            }
        }
        return pages
        
    }
}

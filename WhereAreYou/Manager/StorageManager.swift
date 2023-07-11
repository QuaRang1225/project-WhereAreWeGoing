//
//  StorageManager.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/10.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager{
    
    static let shared = StorageManager()
    private init(){}
    
    private let storage = Storage.storage().reference()
    
    private var imageRef:StorageReference{  //이미지 폴터경로
        storage.child("iamges")
    }
    private func userReferance(userId:String) -> StorageReference{  //메타데이터
        storage.child("users").child(userId)
    }
    private func getProfileImageURL(path:String) -> StorageReference{   //이미지 Url 가져오다
        Storage.storage().reference(withPath: path)
    }
    
    func getUrlForImage(path:String) async throws -> URL{   //메타데이터 경로 다운로드
        try await getProfileImageURL(path: path).downloadURL()
    }
    func saveImage(data:Data,userId:String)async throws -> (String,String){
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReferance(userId: userId).child(path).putDataAsync(data,metadata: meta)
        
        guard let returnedpPath = returnedMetaData.path, let returnedName = returnedMetaData.name else{
            throw URLError(.badServerResponse)
        }
        
        return (returnedpPath,returnedName)
        
    }
    func saveImage(image:UIImage,userId:String) async throws -> (String,String){
        guard let data = image.jpegData(compressionQuality: 1)else{ //퀄리티성정
            throw URLError(.badServerResponse)
        }
        return try await saveImage(data: data, userId: userId)
    }
    func deleteImage(path:String) async throws{
        try await getProfileImageURL(path: path).delete()
    }
    
    
    
    
}

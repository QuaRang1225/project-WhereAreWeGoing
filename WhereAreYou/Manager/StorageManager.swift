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
    
    
    private func userReferance(userId:String,mode:ImageSaveFilter,pageId:String?) -> StorageReference{  //메타데이터
        switch mode{
        case .page:
            return storage.child("page_image").child(userId)
        case .profile:
            return storage.child("users").child(userId)
        case .schedule:
            return storage.child("schedule").child(pageId ?? "").child(userId)
        }
    }
    
    private func getProfileImageURL(path:String) -> StorageReference{   //이미지 Url 가져오다
        Storage.storage().reference(withPath: path)
    }
    
    func getUrlForImage(path:String) async throws -> URL{   //메타데이터 경로 다운로드
        try await getProfileImageURL(path: path).downloadURL()
    }
    
    func saveImage(data:Data,userId:String,mode:ImageSaveFilter) async throws -> String{
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReferance(userId: userId,mode: mode,pageId: nil).child(path).putDataAsync(data,metadata: meta)
        
        guard let returnedpPath = returnedMetaData.path else{
            throw URLError(.badServerResponse)
        }
        
        return returnedpPath
        
    }
    
    func scheduleSaveImage(data:Data,userId:String,mode:ImageSaveFilter,pageId:String)async throws -> String{
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReferance(userId: userId,mode: mode,pageId: pageId).child(path).putDataAsync(data,metadata: meta)
        
        guard let returnedpPath = returnedMetaData.path else{
            throw URLError(.badServerResponse)
        }
        
        return returnedpPath
        
    }
    
    func deleteImage(path:String) async throws{
        do {
            try await getProfileImageURL(path: path).delete()
        } catch let error {
            print("사진삭제실패 : \(error.localizedDescription)")
        }
        
    }
    func deleteAllPageImage(path:String) async throws{
        let pagePath = userReferance(userId: path, mode: .page,pageId: nil)
        let pageList = try await pagePath.listAll()
        for page in pageList.items{
            do{
                try await page.delete()
            } catch let error {
                print("페이지 사진삭제실패 : \(error.localizedDescription)")
            }
        }
    }
    func deleteAllScheuleImage(userId:String,pageId:String) async throws{
        let schedulePath = storage.child("schedule").child(pageId).child(userId)
        
        let scheduleList = try await schedulePath.listAll()
        print(schedulePath)
        print(scheduleList)
        for schedule in scheduleList.items{
            do{
                try await schedule.delete()
            } catch let error {
                print("스케쥴 사진삭제실패 : \(error.localizedDescription)")
            }
        }
    }
    
}




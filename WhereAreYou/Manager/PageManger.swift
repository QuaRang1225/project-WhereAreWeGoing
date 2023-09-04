//
//  PageManger.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class PageManager{
    
    static let shared = PageManager()
    private init(){}
    
    private let userCollection = Firestore.firestore().collection("users")  //경로 설정
    
    private func userDocument(userId:String) -> DocumentReference{
        userCollection.document(userId)
    }
    private func userPageDocumentCollection(userId:String) -> CollectionReference{
        userDocument(userId:userId).collection("page")
    }
    private func userScheduleDocumentCollection(userId:String,pageId:String) -> CollectionReference{
        userPageDocumentCollection(userId: userId).document(pageId).collection("schedule")
    }
    
    func createUserPage(userId:String,url:URL?,path:String?,pageInfo:Page)async throws{
        let document = userPageDocumentCollection(userId: userId).document()
        let documentId = document.documentID
                
        let data:[String:Any] = [
            "page_id":documentId,
            "page_admin":userId,
            "page_image_url":url?.absoluteString,
            "page_image_path":path,
            "page_name":pageInfo.pageName,
            "page_subscript":pageInfo.pageSubscript,
            "page_overseas":pageInfo.pageOverseas,
            "date_range":pageInfo.dateRange,
            
        ]
        try await document.setData(data,merge: false)
        
    }
    func upadateUserPage(userId:String,url:URL?,path:String?,pageInfo:Page)async throws{
        let document = userPageDocumentCollection(userId: userId).document(pageInfo.pageId)
        let documentId = document.documentID
                
        var data:[String:Any] = [:]
        
        if let url,let path{
            data = [
                "page_id":documentId,
                "page_admin":userId,
                "page_image_url":url.absoluteString,
                "page_image_path":path,
                "page_name":pageInfo.pageName,
                "page_subscript":pageInfo.pageSubscript,
                "page_overseas":pageInfo.pageOverseas,
                "date_range":pageInfo.dateRange,
                
            ]
        }else{
            data = [
                "page_id":documentId,
                "page_admin":userId,
                "page_name":pageInfo.pageName,
                "page_subscript":pageInfo.pageSubscript,
                "page_overseas":pageInfo.pageOverseas,
                "date_range":pageInfo.dateRange,
                
            ]
        }
        print(data)
        try await document.updateData(data)
        
    }
    
    func createUserSchedule(userId:String,pageId:String,url:String?,schedule:Schedule,path:String?)async throws{
        let field = userPageDocumentCollection(userId: userId).document(pageId).collection("schedule").document()
        let schduleId = field.documentID
          

        let data:[String:Any] = [
            "id" : schduleId,
            "image_url" : url,
            "image_url_path":path,
            "category" : schedule.category,
            "title" : schedule.title,
            "start_time" : schedule.startTime,
            "end_time" : schedule.endTime,
            "content" : schedule.content,
            "location" : schedule.location,
            "link":schedule.link
        ]
        try await field.setData(data,merge: false)
        
    }
    func updateUSerSchedule(userId:String,pageId:String,url:URL?,schedule:Schedule,path:String?)async throws{
        
        let field = userPageDocumentCollection(userId: userId).document(pageId).collection("schedule").document(schedule.id)
        var data:[String:Any] = [:]
        
        if let url,let path{
             data = [
                "image_url_path" : path,
                "image_url" : url.absoluteString,
                "category" : schedule.category,
                "title" : schedule.title,
                "start_time" : schedule.startTime,
                "end_time" : schedule.endTime,
                "content" : schedule.content,
                "location" : schedule.location,
                "link":schedule.link
            ]
        }else{
            data = [
               "category" : schedule.category,
               "title" : schedule.title,
               "start_time" : schedule.startTime,
               "end_time" : schedule.endTime,
               "content" : schedule.content,
               "location" : schedule.location,
               "link":schedule.link
           ]
        }
        try await field.updateData(data)
        
    }
    func deleteUserSchedule(userId:String,pageId:String,scheduleId:String) async throws{
        let field = userPageDocumentCollection(userId: userId).document(pageId).collection("schedule").document(scheduleId)
        try await field.delete()
    }
    func deleteUserPage(userId:String,pageId:String) async throws{
        let field = userPageDocumentCollection(userId: userId).document(pageId)
        try await field.delete()
    }
    func getAllPage(userId:String)async throws -> [Page]{    //전체페이지 불러오기
        try await userPageDocumentCollection(userId: userId).getDocuments(as: Page.self)
    }
    func getAllSchedule(userId:String,pageId:String)async throws -> [Schedule]{    //전체스케쥴 불러오기
       try await userScheduleDocumentCollection(userId: userId, pageId: pageId).getDocuments(as: Schedule.self)

    }
}

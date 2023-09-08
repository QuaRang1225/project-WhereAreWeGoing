//
//  PageManger.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//

import Foundation

import FirebaseFirestore
import FirebaseFirestoreSwift

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
            "page_image_url":url?.absoluteString as Any,
            "page_image_path":path as Any,
            "page_name":pageInfo.pageName,
            "page_subscript":pageInfo.pageSubscript,
            "page_overseas":pageInfo.pageOverseas,
            "date_range":pageInfo.dateRange,
            
        ]
        print("페이지 생성중..")
        try await document.setData(data,merge: false)
        
    }
    func upadateUserPage(userId:String,url:String?,path:String?,pageInfo:Page)async throws{
        let document = userPageDocumentCollection(userId: userId).document(pageInfo.pageId)
        
        var data:[String:Any] = [:]
        
        data = [
            "page_name":pageInfo.pageName,
            "page_subscript":pageInfo.pageSubscript,
            "page_overseas":pageInfo.pageOverseas,
            "date_range":pageInfo.dateRange
            
        ]
       
        if let url,let path{
            data["page_image_url"] = url == "x" ? NSNull() : url
            data["page_image_path"] = path == "x" ? NSNull(): path
        }
        try await document.updateData(data as [AnyHashable : Any])
        
    }
    
    func createUserSchedule(userId:String,pageId:String,url:String?,schedule:Schedule,path:String?)async throws{
        let field = userPageDocumentCollection(userId: userId).document(pageId).collection("schedule").document()
        let schduleId = field.documentID
        
        
        let data:[String:Any] = [
            "id" : schduleId,
            "image_url" : url as Any,
            "image_url_path":path as Any,
            "category" : schedule.category,
            "title" : schedule.title,
            "start_time" : schedule.startTime,
            "end_time" : schedule.endTime,
            "content" : schedule.content,
            "location" : schedule.location,
            "link":schedule.link as Any
        ]
        print("스케쥴 생성중..")
        try await field.setData(data,merge: false)
        
    }
    func updateUSerSchedule(userId:String,pageId:String,url:String?,schedule:Schedule,path:String?)async throws{
        
        let field = userPageDocumentCollection(userId: userId).document(pageId).collection("schedule").document(schedule.id)
        var data:[String:Any] = [:]
        
        data = [
            "category" : schedule.category,
            "title" : schedule.title,
            "start_time" : schedule.startTime,
            "end_time" : schedule.endTime,
            "content" : schedule.content,
            "location" : schedule.location,
            "link":schedule.link as Any
        ]
        
        if let url,let path{
            data["image_url_path"] = url == "x" ? NSNull() : path
            data["image_url"] = path == "x" ? NSNull(): url
        }
        try await field.updateData(data as [AnyHashable : Any])
        
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
        try await userPageDocumentCollection(userId: userId).getAllDocuments(as: Page.self)
    }
    func getAllSchedule(userId:String,pageId:String)async throws -> [Schedule]{    //전체스케쥴 불러오기
        try await userScheduleDocumentCollection(userId: userId, pageId: pageId).getAllDocuments(as: Schedule.self)
        
    }
    func getPage(userId:String,pageId:String)async throws -> Page{
        try await userPageDocumentCollection(userId: userId).document(pageId).getDocument(as:Page.self)
    }
    func getSchedule(userId:String,pageId:String,scheduleId:String)async throws -> Schedule{
        try await userScheduleDocumentCollection(userId: userId, pageId: pageId).document(scheduleId).getDocument(as: Schedule.self)
    }
    
}

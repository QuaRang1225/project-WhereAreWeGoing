//
//  PageManger.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//

import Foundation

import Firebase
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
        print("페이지 수정중..")
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
        print("스케쥴 수정중..")
        try await field.updateData(data as [AnyHashable : Any])
        
    }
    
    func requestPage(user:UserData,pageAdminId:String,pageId:String,cancel:Bool) async throws{
        let pagePath = userPageDocumentCollection(userId: pageAdminId).document(pageId)
        let data:[String:Any] = ["request_user": cancel ? FieldValue.arrayRemove([user.userId]) : FieldValue.arrayUnion([user.userId])]
        print("페이지 맴버 요청중..")
        try await pagePath.updateData(data)
    }
    func managingMemberPage(user:UserData,pageAdminId:String,pageId:String,cancel:Bool) async throws{
        let pagePath = userPageDocumentCollection(userId: pageAdminId).document(pageId)
        let data:[String:Any] = ["member": cancel ? FieldValue.arrayRemove([user.userId]) : FieldValue.arrayUnion([user.userId])]
        print(cancel ? "맴버 삭제중.." : "맴버 추가중..")
        try await pagePath.updateData(data)
    }
    func deleteUserSchedule(userId:String,pageId:String,scheduleId:String) async throws{
        let field = userPageDocumentCollection(userId: userId).document(pageId).collection("schedule").document(scheduleId)
        print("스케쥴 삭제중..")
        try await field.delete()
    }
    func deleteUserPage(userId:String,pageId:String) async throws{
        let field = userPageDocumentCollection(userId: userId).document(pageId)
        print("페이지 삭제중..")
        try await field.delete()
    }
    func getAllPage(userId:String)async throws -> [Page]{    //전체페이지 불러오기
        print("전체페이지 불러오는 중..")
        return try await userPageDocumentCollection(userId: userId).getAllDocuments(as: Page.self)
    }
    func getAllSchedule(userId:String,pageId:String)async throws -> [Schedule]{    //전체스케쥴 불러오기
        print("전체스케쥴 불러오는 중..")
        return try await userScheduleDocumentCollection(userId: userId, pageId: pageId).getAllDocuments(as: Schedule.self)
        
    }
    func getPage(userId:String,pageId:String)async throws -> Page{
        print("페이지 불러오는 중..")
        return try await userPageDocumentCollection(userId: userId).document(pageId).getDocument(as:Page.self)
    }
    func getSchedule(userId:String,pageId:String,scheduleId:String)async throws -> Schedule{
        print("스케쥴 불러오는 중..")
        return try await userScheduleDocumentCollection(userId: userId, pageId: pageId).document(scheduleId).getDocument(as: Schedule.self)
    }
    func acceptUser(user:UserData,page:Page,requestUser:UserData)async throws{
        try await requestPage(user: requestUser, pageAdminId: page.pageAdmin, pageId: page.pageId, cancel: true)   //초대요청 삭제
        try await managingMemberPage(user: requestUser, pageAdminId: page.pageAdmin, pageId: page.pageId, cancel: false)   //맴버 리스트 추가
            
        let pagePath = userPageDocumentCollection(userId: user.userId).document(page.pageId).path
        let requestUserField = userDocument(userId: requestUser.userId)
        
        let data:[String:Any] = ["pages":FieldValue.arrayUnion([pagePath])]
        print("유저 요청 수락 중")
        try await requestUserField.updateData(data)
        
    }
    func getNotAdminPages(user:UserData) async throws -> [Page]{
        var myPages:[Page] = []
        guard let pages = user.pages else { return myPages }
        for page in pages {
            myPages.append(try await Firestore.firestore().document(page).getDocument(as:Page.self))
        }
        return myPages
    }
}

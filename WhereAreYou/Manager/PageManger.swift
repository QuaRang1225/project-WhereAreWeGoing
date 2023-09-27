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
    private let pageCollection = Firestore.firestore().collection("pages")  //경로 설정
    
    private func userDocument(userId:String) -> DocumentReference{
        userCollection.document(userId)
    }

    private func pageDocument(pageId:String) -> DocumentReference{
        pageCollection.document(pageId)
    }
    private func scheduleCollection(pageId:String) -> CollectionReference{
        pageDocument(pageId: pageId).collection("schedule")
    }
    private func scheduleDocument(pageId:String,scheduleId:String) -> DocumentReference{
        pageDocument(pageId: pageId).collection("schedule").document(scheduleId)
    }
    func createUserPage(userId:String,url:URL?,path:String?,pageInfo:Page)async throws -> String{
        let document = pageCollection.document()
        
        let data:[String:Any] = [
            "page_id":document.documentID,
            "page_admin":userId,
            "page_image_url":url?.absoluteString as Any,
            "page_image_path":path as Any,
            "page_name":pageInfo.pageName,
            "page_subscript":pageInfo.pageSubscript,
            "page_overseas":pageInfo.pageOverseas,
            "members":FieldValue.arrayUnion([userId]),
            "date_range":pageInfo.dateRange,
            
        ]
        
        print("페이지 생성중..")
        try await document.setData(data,merge: false)
        return document.documentID
        
    }
    func upadateUserPage(userId:String,url:String?,path:String?,pageInfo:Page)async throws{
        let document = pageDocument(pageId: pageInfo.pageId)
        
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
    
    func createUserSchedule(pageId:String,url:String?,schedule:Schedule,path:String?)async throws{
        let field = pageDocument(pageId: pageId).collection("schedule").document()
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
        
        let field = pageDocument(pageId: pageId).collection("schedule").document(schedule.id)
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
    
    func requestPage(user:UserData,pageId:String,cancel:Bool) async throws{
        let pagePath = pageDocument(pageId: pageId)
        let data:[String:Any] = ["request_user": cancel ? FieldValue.arrayRemove([user.userId]) : FieldValue.arrayUnion([user.userId])]
        print("페이지 맴버 요청중..")
        try await pagePath.updateData(data)
    }
    func memberPage(user:UserData,pageId:String,cancel:Bool) async throws{
        let pagePath = pageDocument(pageId: pageId)
        
        let data:[String:Any] = ["members": cancel ? FieldValue.arrayRemove([user.userId]) : FieldValue.arrayUnion([user.userId])]
        
        print(cancel ? "맴버 삭제중.." : "맴버 추가중..")
        try await UserManager.shared.updatePages(userId: user.userId, pagesId: pageId)
        try await pagePath.updateData(data)
    }
    func deleteUserSchedule(pageId:String,scheduleId:String) async throws{
        let field = pageDocument(pageId: pageId).collection("schedule").document(scheduleId)
        print("스케쥴 삭제중..")
        try await field.delete()
    }
    func deleteUserPage(pageId:String) async throws{
        try await pageDocument(pageId: pageId).delete()
    }
    func updateMemberPage(userId:String,pageId:String)async throws{
        let user = userDocument(userId: userId)
        let userdata:[String:Any] = ["pages":FieldValue.arrayRemove([pageId])]
        
        try await user.updateData(userdata)
    }
    func getAllUserPage(userId:String)async throws -> [Page]{    //전체페이지 불러오기
        let pages = pageCollection.whereField("members", arrayContains: userId)
        print("전체페이지 불러오는 중..")
        return try await pages.getAllDocuments(as: Page.self)
    }
    func getAllUserSchedule(pageId:String)async throws -> [Schedule]{    //전체스케쥴 불러오기
        print("전체스케쥴 불러오는 중..")
        return try await scheduleCollection(pageId: pageId).getAllDocuments(as: Schedule.self)
        
    }
    func getPage(pageId:String)async throws -> Page{
        print("페이지 불러오는 중..")
        return try await pageDocument(pageId: pageId).getDocument(as:Page.self)
    }
    func getSchedule(pageId:String,scheduleId:String)async throws -> Schedule{
        print("스케쥴 불러오는 중..")
        return try await scheduleDocument(pageId: pageId, scheduleId: scheduleId).getDocument(as:Schedule.self)
    }
    func acceptUser(pageId:String,requestUser:UserData)async throws{
        try await requestPage(user: requestUser, pageId: pageId, cancel: true) //수락 후 요청 목록에서 삭제
        try await memberPage(user: requestUser, pageId: pageId, cancel: false)   //맴버 리스트 추가
        print("유저 요청 수락 중")
    }
    func getMembersInfo(page:Page)async throws -> ([UserData],[UserData]){
        var request:[UserData] = []
        var member:[UserData] = []
        
        for req in page.request ?? []{
            let person = try await UserManager.shared.getUser(userId: req)
            request.append(person)
        }
        for mem in page.members ?? []{
            let person = try await UserManager.shared.getUser(userId: mem)
            member.append(person)
        }
        
       return (request,member)
    }
}



//
//  EditViewModel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/22.
//

import Foundation
import PhotosUI
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

@MainActor
class PageViewModel:ObservableObject{
    
    //---------Firestore데이터 ------------
    @Published var page:Page? = nil
    @Published var schedule:Schedule? = nil
    @Published var pages:[Page] = []
    @Published var schedules:[Schedule] = []
    
    //-----------프로필 선택 ---------------
    @Published var data:Data? = nil
    @Published var selection:PhotosPickerItem? = nil
    
    
    //---------- 기타공유 프로퍼티 -----------
    @Published var copy = false
    @Published var photo:String?
    
    //--------- 페이지 -------------
    @Published var request:[UserData] = []
    @Published var member:[UserData] = []
    
    //---------- 뷰 이벤트 -----------
    var addDismiss = PassthroughSubject<(),Never>()
    var pageDismiss = PassthroughSubject<(),Never>()
    
    //
    //--------------페이지-----------------------
    //
    
    //페이지 생성
    func creagtePage(user:UserData,pageInfo:Page){
        
        Task{
            var url:URL? = nil
            var path:String? = nil

            if let data = try await selection?.loadTransferable(type: Data.self){
                path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .page)
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "")
            }
            try await PageManager.shared.createUserPage(userId: user.userId,url: url ,path: path, pageInfo: pageInfo)
            addDismiss.send()
        }
    }
    //페이지 수정
    func updatePage(user:UserData,pageInfo:Page){
        
        Task{
            var url:String? = nil
            var path:String? = nil
            
            if let data = try await selection?.loadTransferable(type: Data.self){
                if let image = pageInfo.pageImagePath{
                    if image != ""{    //원래 사진이 있고(아예없거나 비어있을때) 다른 사진으로 바꾸는 경우
                        try await StorageManager.shared.deleteImage(path: image)
                    }
                }
                path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .page)    //사진이 없었지만 추가하는 경우
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "").absoluteString
                
            }else if self.page?.pageImageUrl == nil{    //사진이 있다가 없애는경우
                url = "x"
                path = "x"
            }
            try await PageManager.shared.upadateUserPage(userId: user.userId,url: url, path: path, pageInfo: pageInfo)
            self.page = try await PageManager.shared.getPage(pageId: pageInfo.pageId)
            addDismiss.send()
        }
    }
    //페이지 삭제
    func deletePage(userId:String,page:Page){
        Task{
            guard let path = page.pageImagePath else { return }
            try await StorageManager.shared.deleteImage(path: path) //페이지 이미지가 없을 경우 필요가 없는 부분
            try await PageManager.shared.deleteUserPage(userId:userId,pageId: page.pageId)
            pageDismiss.send()
        }
    }
    //페이지 나감
    func outPage(user:UserData,page:Page){
        Task{
            try await PageManager.shared.memberPage(user: user,pageId: page.pageId, cancel: true)
            pageDismiss.send()
        }
    }
    //페이지리스트 불러오기
    func getPages(user:UserData){
        Task{
            pages = try await PageManager.shared.getAllUserPage(userId: user.userId)
        }
    }
    //페이지 불러오기
    func getPage(pageId:String){
        Task{
            self.page = try await PageManager.shared.getPage(pageId: pageId)
        }
    }
    
    //
    //--------------페이지-----------------------
    //
    
    //일정 생성
    func creagteShcedule(user:UserData,pageId:String,schedule:Schedule){
        
        Task{
            var url = URL(string: "")
            var path:String? = nil
            if let data = try await selection?.loadTransferable(type: Data.self){
                path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .schedule)
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "")
            }
            try await PageManager.shared.createUserSchedule(pageId: pageId, url: url?.absoluteString, schedule: schedule,path:path)
            addDismiss.send()
        }
    }
    //일정 수정
    func updateSchedule(user:UserData,pageId:String,schedule:Schedule){
        Task{
            var url:String? = nil
            var path:String? = nil
            
            if let data = try await selection?.loadTransferable(type: Data.self){
                if let image = schedule.imageUrlPath{
                    if image != ""{    //원래 사진이 있고(아예없거나 비어있을때) 다른 사진으로 바꾸는 경우
                        try await StorageManager.shared.deleteImage(path: image)
                    }
                }
                path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .schedule)    //사진이 없었지만 추가하는 경우
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "").absoluteString
                
            }
            else if self.schedule?.imageUrl == nil{    //사진이 있다가 없애는경우
                url = "x"
                path = "x"
            }
            try await PageManager.shared.updateUSerSchedule(userId: user.userId, pageId: pageId, url: url, schedule: schedule,path: path)
            addDismiss.send()
        }
    }
    
    //일정 삭제
    func deleteSchedule(pageId:String,schedule:Schedule){
        Task{
            guard let path = schedule.imageUrlPath else {return}
            try await StorageManager.shared.deleteImage(path: path) //스케쥴 이미지가 없을 경우 필요가 없는 부분
            try await PageManager.shared.deleteUserSchedule(pageId: pageId, scheduleId: schedule.id)
            getSchedules(pageId: pageId)
        }
    }
    
    //일정리스트 불러오기
    func getSchedules(pageId:String){
        Task{
            schedules = try await PageManager.shared.getAllUserSchedule(pageId: pageId)
        }
    }
    
    
    //
    //---------------기능------------------
    //
    
    //요청리스트와 맴버리스트 조회
    func getMembers(page:Page){
        Task{
            (self.request,self.member) = try await PageManager.shared.getMembersInfo(page:page)
        }
    }
    //페이지 요청 수락
    func userAccept(page:Page,requestUser:UserData){
        Task{
            try await PageManager.shared.acceptUser(pageId:page.pageId,requestUser:requestUser)
            let pageInfo = try await PageManager.shared.getPage(pageId: page.pageId)
            (self.request,self.member) = try await PageManager.shared.getMembersInfo(page:pageInfo)
        }
    }
    //페이지 요청
    func requestPage(user:UserData,pageId:String,cancel:Bool){
        Task{
            try await PageManager.shared.requestPage(user:user,pageId:pageId,cancel:!cancel)
        }
    }

    
    //
    //-------------------------기타--------------------------
    //
    
    //시작과 끝 날짜를 입력하면 그 사이에 있는 값을 배열로 반화
    func generateTimestamp(from: Date, to: Date) -> [Timestamp] {
        var currentDate = from
        var dateArray: [Timestamp] = []
        let calendar = Calendar.current
        
        while currentDate <= to {
            let midnightDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate)!
            dateArray.append(Timestamp(date: midnightDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return dateArray
    }
    
    //클립보드 복사
    func copyToPasteboard(text:String) {
        UIPasteboard.general.string = text
        copy = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.copy = false
            }
        }
    }
    //현재 날짜가 입력한 날짜 범위안에 들어있는지 유무를 반환
    func isCurrentDateInRange(startDate: Date, endDate: Date) -> Bool {
        let currentDate = Date()
        if currentDate >= startDate && currentDate <= endDate {
            return true
        } else {
            return false
        }
    }
    
}









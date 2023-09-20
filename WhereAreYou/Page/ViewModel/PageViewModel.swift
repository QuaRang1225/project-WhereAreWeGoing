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
import Combine

@MainActor
class PageViewModel:ObservableObject{
    
    //---------Firestore데이터 ------------
    @Published var page:Page? = nil
    //    @Published var admin:UserData? = nil
    @Published var schedule:Schedule? = nil
    @Published var pages:[Page] = []
    @Published var schedules:[Schedule] = []
    
    //-----------프로필 선택 ---------------
    @Published var data:Data? = nil
    @Published var selection:PhotosPickerItem? = nil
    
    
    //---------- 기타공유 프로퍼티 -----------
    @Published var copy = false
    @Published var photo:String?
    
    //--------- 맴버 -------------
    @Published var admin:UserData?
    @Published var request:[UserData] = []
    @Published var member:[UserData] = []
    
    //    var createPageSuccess = PassthroughSubject<(),Never>()
    //    var createScheduleSuccess = PassthroughSubject<(),Never>()
    var succenss = PassthroughSubject<(),Never>()
    var deleteSuccess = PassthroughSubject<(),Never>()
    
    func creagtePage(user:UserData,pageInfo:Page){
        
        Task{
            var url:URL? = nil
            var path:String? = nil
            
            if let data = try await selection?.loadTransferable(type: Data.self){
                path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .page)
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "")
            }
            try await PageManager.shared.createUserPage(userId: user.userId,url: url ,path: path, pageInfo: pageInfo)
            succenss.send()
            //            createPageSuccess.send()
        }
    }
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
            self.page = try await PageManager.shared.getPage(userId: user.userId, pageId: pageInfo.pageId)
            succenss.send()
        }
    }
    
    func creagteShcedule(user:UserData,pageId:String,schedule:Schedule){
        
        Task{
            //            do{
            var url = URL(string: "")
            var path:String? = nil
            if let data = try await selection?.loadTransferable(type: Data.self){
                path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .schedule)
                url = try await StorageManager.shared.getUrlForImage(path: path ?? "")
            }
            
            try await PageManager.shared.createUserSchedule(userId: user.userId, pageId: pageId, url: url?.absoluteString, schedule: schedule,path:path)
            succenss.send()
        }
    }
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
            succenss.send()
        }
    }
    func deletePage(user:UserData,page:Page){
        Task{
            if let path = page.pageImagePath{
                try await StorageManager.shared.deleteImage(path: path) //페이지 이미지가 없을 경우 필요가 없는 부분
            }
            try await PageManager.shared.deleteUserPage(userId:user.userId,pageId:page.pageId)
            getPages(user: user)
            deleteSuccess.send()
        }
    }
    
    func deleteSchedule(user:UserData,pageId:String,schedule:Schedule){
        Task{
            if let path = schedule.imageUrlPath{
                try await StorageManager.shared.deleteImage(path: path) //스케쥴 이미지가 없을 경우 필요가 없는 부분
            }
            try await PageManager.shared.deleteUserSchedule(userId:user.userId,pageId:pageId,scheduleId:schedule.id)
            deleteSuccess.send()
        }
    }
    
    func getPages(user:UserData){
        Task{
            do{
                pages = try await PageManager.shared.getAllPage(userId: user.userId)
                getNotAdminPage(user: user)
            }catch{}
        }
    }
    func getSchedules(userId:String,pageId:String){
        Task{
            schedules = try await PageManager.shared.getAllSchedule(userId: userId, pageId: pageId)
        }
    }
    func getPage(userId:String,pageId:String){
        Task{
            page = try await PageManager.shared.getPage(userId: userId, pageId: pageId)
        }
    }

    func getMembers(page:Page){
        Task{
            self.request.removeAll()
            self.member.removeAll()
            for req in page.request ?? []{
                let person = try await UserManager.shared.getUser(userId: req)
                self.request.append(person)
            }
            for mem in page.member ?? []{
                let person = try await UserManager.shared.getUser(userId: mem)
                self.member.append(person)
            }
        }
    }
    func userAccept(user:UserData,page:Page,requestUser:UserData){
        Task{
            try await PageManager.shared.acceptUser(user:user,page:page,requestUser:requestUser)
            self.getMembers(page: try await PageManager.shared.getPage(userId: user.userId, pageId: page.pageId))
        }
    }
    
    func getNotAdminPage(user:UserData){
        Task{
            pages.append(contentsOf: try await PageManager.shared.getNotAdminPages(user:user))
        }
    }
    
    
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
    
    func copyToPasteboard(text:String) {
        UIPasteboard.general.string = text
        copy = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.copy = false
            }
        }
    }
    func isCurrentDateInRange(startDate: Date, endDate: Date) -> Bool {
        let currentDate = Date()
        if currentDate >= startDate && currentDate <= endDate {
            return true
        } else {
            return false
        }
    }
    
}









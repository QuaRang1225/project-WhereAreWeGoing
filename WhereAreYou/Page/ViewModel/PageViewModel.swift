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
    
    @Published var page:Page? = nil
    @Published var admin:UserData? = nil
    @Published var modifingSchecdule:Schedule? = nil
    @Published var pages:[Page] = []
    @Published var schedules:[Schedule] = []
    
    @Published var data:Data? = nil
    @Published var selection:PhotosPickerItem? = nil
    
    @Published var copy = false
    var createPageSuccess = PassthroughSubject<(),Never>()
    var createScheduleSuccess = PassthroughSubject<(),Never>()
    var deleteSuccess = PassthroughSubject<(),Never>()
    
    func creagtePage(user:UserData,pageInfo:PageInfo){
        
        Task{
            guard let data = try await selection?.loadTransferable(type: Data.self) else {return}
           
            let path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .page)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await PageManager.shared.createUserPage(userId: user.userId,url: url.absoluteString, pageInfo: pageInfo)
            
            createPageSuccess.send()
        }
    }
    
    func creagteShcedule(user:UserData,pageId:String,schedule:Schedule){
        
        Task{
            var url = URL(string: "")
            if let data = try await selection?.loadTransferable(type: Data.self){
                let path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .schedule)
                url = try await StorageManager.shared.getUrlForImage(path: path)
            }
            
            try await PageManager.shared.createUserSchedule(userId: user.userId, pageId: pageId, url: url?.absoluteString, schedule: schedule)
            createScheduleSuccess.send()
        }
    }
    func updateSchedule(user:UserData,pageId:String,schedule:Schedule){
        Task{
            var url:URL? = nil
            if let data = try await selection?.loadTransferable(type: Data.self){
                let path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .schedule)
                url = try await StorageManager.shared.getUrlForImage(path: path)
            }
            
            try await PageManager.shared.updateUSerSchedule(userId: user.userId, pageId: pageId, url: url, schedule: schedule)
            createScheduleSuccess.send()
        }
    }
    func deleteSchedule(user:UserData,pageId:String,schedule:Schedule){
        Task{
            try await PageManager.shared.deleteUserSchedule(userId:user.userId,pageId:pageId,scheduleId:schedule.id)
            deleteSuccess.send()
        }
    }
    func getPages(user:UserData){
        Task{
            pages = try await PageManager.shared.getAllPage(userId: user.userId)
        }
    }
    func getSchedule(user:UserData,pageId:String){
        Task{
            schedules = try await PageManager.shared.getAllSchedule(userId: user.userId, pageId: pageId)
        }
    }
    
    func generateTimestamp(from: Date, to: Date) -> [Date] {
        var currentDate = from
        var dateArray: [Date] = []
        let calendar = Calendar.current
        
        while currentDate <= to {
            let midnightDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate)!
            dateArray.append(midnightDate)
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

}









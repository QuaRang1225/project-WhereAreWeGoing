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
    @Published var pages:[Page] = []
    @Published var schedules:[Schedule] = []
    
    @Published var data:Data? = nil
    @Published var selection:PhotosPickerItem? = nil
    
    
    var createPageSuccess = PassthroughSubject<(),Never>()
    var createScheduleSuccess = PassthroughSubject<(),Never>()
    
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
    
//    func getUser(userId:String){
//        Task{
//            admin = try await UserManager.shared.getUser(userId:userId)
//        }
//    }
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
    func generateTimestamp(from startDate: Date, to endDate: Date) -> [Date] {
        var datesArray: [Date] = []
        let calendar = Calendar.current

        var currentDate = startDate
        while currentDate <= endDate {
            let dateString = currentDate
            datesArray.append(dateString)
            if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                currentDate = nextDate
            } else {
                break
            }
        }

        return datesArray
    }
}









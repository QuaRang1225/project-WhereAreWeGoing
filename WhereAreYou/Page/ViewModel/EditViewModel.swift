//
//  EditViewModel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/22.
//

import Foundation
import PhotosUI
import SwiftUI
import Firebase
import Combine

@MainActor
class EditViewModel:ObservableObject{
    
    @Published var pages:[Page] = []
    @Published var data:Data? = nil
    @Published var selection:PhotosPickerItem? = nil
    
    
    var createPageSuccess = PassthroughSubject<(),Never>()
    
    func creagtePage(user:UserData,pageInfo:PageInfo){
        
        Task{
            guard let data = try await selection?.loadTransferable(type: Data.self) else {return}
           
            let path = try await StorageManager.shared.saveImage(data:data,userId: user.userId, mode: .page)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.createUserPage(userId: user.userId,url: url.absoluteString, pageInfo: pageInfo)
            createPageSuccess.send()
        }
    }
    
    func getPages(user:UserData){
        Task{
            pages = try await UserManager.shared.getAllUserFavoriteProduct(userId: user.userId)
        }
    }
}









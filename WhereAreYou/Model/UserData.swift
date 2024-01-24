//
//  UserData.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/08.
//

import Foundation
import Firebase
import FirebaseFirestore

struct UserData:Codable,Hashable{
    
    let userId:String
    var nickName:String?
    let email:String?
    let dateCreated:String
    var profileImageUrl:String?
    var profileImagePath:String?
    var pages:[String]?
    var guestMode:Bool
    
    init(userId:String,nickname:String?,email:String?,dateCreated:String,profileImageUrl:String?,profileImagePath:String?,pages:[String],guestMode:Bool){
        self.userId = userId
        self.nickName = nickname
        self.email = email
        self.dateCreated = dateCreated
        self.profileImagePath = profileImagePath
        self.profileImageUrl = profileImageUrl
        self.pages = pages
        self.guestMode = guestMode
    }
    init(auth:AuthData){  //처음 값을 저장할때 - 인증
        self.userId = auth.uid
        self.email = auth.email
        self.nickName = nil
        self.dateCreated = "\(Timestamp().dateValue())"
        self.profileImageUrl = nil
        self.profileImagePath = nil
        self.pages = nil
        self.guestMode = true
    }
}

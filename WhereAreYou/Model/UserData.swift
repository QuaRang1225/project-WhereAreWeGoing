//
//  UserData.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/08.
//

import Foundation
import Firebase

struct UserData:Codable{
    
    let userId:String
    var nickName:String?
    let email:String?
    let dateCreated:Date?
    var profileImageUrl:String?
    var guestMode:Bool
    
    init(auth:AuthData){  //처음 값을 저장할때 - 인증
        self.userId = auth.uid
        self.email = auth.email
        self.nickName = nil
        self.dateCreated = Timestamp().dateValue()
        self.profileImageUrl = nil
        self.guestMode = true
    }
}

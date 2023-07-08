//
//  Auth.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/08.
//

import Foundation
import Firebase

struct AuthData{
    let uid:String
    let email:String?
    
    init(user:User) {   //코드의 간결성을 위해 같은 메서드의 값일 경우 이렇게 일체화 가능
        self.uid = user.uid
        self.email = user.email
    }
}

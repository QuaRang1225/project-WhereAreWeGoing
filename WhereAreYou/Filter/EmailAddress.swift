//
//  EmailAddress.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import Foundation

enum EmailAddress:CaseIterable{
    case gmail
    case naver
    case daum
    case hanmail
    case icloud
    case outlook
    
    var name:String{
        switch self{
        case .gmail:
            return "gmail.com"
        case .naver:
            return "naver.com"
        case .daum:
            return "daum.net"
        case .hanmail:
            return "hanmail.net"
        case .icloud:
            return "icloud.com"
        case .outlook:
            return "outlook.com"
        }
    }
}

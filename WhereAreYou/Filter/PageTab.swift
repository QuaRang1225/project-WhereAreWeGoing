//
//  PageTab.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/28.
//

import Foundation

enum PageTabFilter:CaseIterable{
    case schedule
    case member
    case request
    
    var image:String{
        switch self{
        case .schedule:
            return "list.bullet"
        case .member:
            return "person.2"
        case .request:
            return "bell.fill"
        }
    }
    var name:String{
        switch self{
        case .schedule:
            return "일정"
        case .member:
            return "맴버"
        case .request:
            return "요청"
        }
    }
}

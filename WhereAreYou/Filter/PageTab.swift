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
    case setting
    
    var image:String{
        switch self{
        case .schedule:
            return "list.bullet"
        case .member:
            return "person.2"
        case .setting:
            return "gearshape"
        }
    }
    var name:String{
        switch self{
        case .schedule:
            return "일정"
        case .member:
            return "맴버"
        case .setting:
            return "설정"
        }
    }
}

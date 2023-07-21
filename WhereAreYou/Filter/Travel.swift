//
//  Travel.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/21.
//

import Foundation

enum TravelFilter:CaseIterable{
    case all
    case domestic
    case overseas
    
    var name:String{
        switch self{
        case .all:
            return "전체"
        case .domestic:
            return "국내"
        case .overseas:
            return "해외"
        }
    }
}

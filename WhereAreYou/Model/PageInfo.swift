//
//  PageInfo.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import Foundation

struct PageInfo:Codable{
    let pageName:String
    let pageSubscript:String
    let dateRange:[Date]
    let overseas:Bool
}

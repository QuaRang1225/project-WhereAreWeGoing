//
//  Page.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import Foundation

struct Page:Codable,Hashable{
    
    let pageId:String
    let pageAdmin:String
    let pageImageUrl:String
    let pageName:String
    let pageOverseas:Bool
    let pageSubscript:String
    
    enum CodingKeys:String,CodingKey{
        case pageId = "page_id"
        case pageAdmin = "page_admin"
        case pageImageUrl = "page_image_url"
        case pageName = "page_name"
        case pageOverseas = "page_overseas"
        case pageSubscript = "page_subscript"
    }
}

//
//  Page.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Page:Codable,Hashable{
    
    let pageId:String
    let pageAdmin:String
    var pageImageUrl:String?
    var pageImagePath:String?
    let pageName:String
    let pageOverseas:Bool
    let pageSubscript:String
    var request:[String]?
    var members:[String]?
    let dateRange:[Timestamp]
    
    enum CodingKeys:String,CodingKey{
        case pageId = "page_id"
        case pageAdmin = "page_admin"
        case pageImageUrl = "page_image_url"
        case pageImagePath = "page_image_path"
        case pageName = "page_name"
        case pageOverseas = "page_overseas"
        case pageSubscript = "page_subscript"
        case request = "request_user"
        case members
        case dateRange = "date_range"
    }
}




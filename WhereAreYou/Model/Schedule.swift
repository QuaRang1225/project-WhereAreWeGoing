//
//  Schendule.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//

import Foundation
import FirebaseFirestore

struct Schedule:Codable,Hashable{
    var id:String
    var imageUrl:String?
    var category:String
    var title:String
    var startTime:Timestamp
    var endTime:Timestamp
    var content:String
    var location:GeoPoint
    var link:[String:String]?
    

    enum CodingKeys:String,CodingKey{
        case id
        case imageUrl = "image_url"
        case category
        case title
        case startTime = "start_time"
        case endTime = "end_time"
        case content
        case location,link
    }
}





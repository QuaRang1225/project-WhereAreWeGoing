//
//  Schendule.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//

import Foundation
import Firebase

struct Schedule:Codable,Hashable{
    
    var imageUrl:String?
    var day:Int
    var category:String
    var title:String
    var startTime:String
    var endTime:String
    var content:String
    var location:GeoPoint
    
    enum CodingKeys:String,CodingKey{
        case imageUrl = "image_url"
        case day
        case category
        case title
        case startTime = "start_time"
        case endTime = "end_time"
        case content
        case location
    }
}

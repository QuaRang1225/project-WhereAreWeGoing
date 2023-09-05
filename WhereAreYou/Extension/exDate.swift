//
//  exDate.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import Foundation
import FirebaseFirestore

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = .init(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    func toStringCalender() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    func toTimeString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.locale = .init(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    func toTimeHourMinuteSecond() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a hh:mm"
        dateFormatter.locale = .init(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    func toTimestamp()->Timestamp{
        Timestamp(date: self)
    }
    
}

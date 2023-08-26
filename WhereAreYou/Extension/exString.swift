//
//  exString.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import Foundation

extension String {
    func toDate() -> Date { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        if let date = dateFormatter.date(from: self) {
            return date
        }else{
            return Date()
        }
    }
    func toDateTime() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

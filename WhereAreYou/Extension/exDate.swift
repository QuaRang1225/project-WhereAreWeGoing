//
//  exDate.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import Foundation

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.string(from: self)
    }
}

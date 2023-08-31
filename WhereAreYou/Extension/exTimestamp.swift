//
//  exTimestamo.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/31.
//

import Foundation
import FirebaseFirestore

extension Timestamp: Comparable {
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.dateValue() < rhs.dateValue()
    }
}

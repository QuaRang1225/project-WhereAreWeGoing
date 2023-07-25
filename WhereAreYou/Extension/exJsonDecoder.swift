//
//  exJsonDecoder.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import Foundation

extension JSONDecoder {
    func decode<T>(_ type: T.Type, fromJSONObject object: Any) throws -> T where T: Decodable {
        return try decode(T.self, from: try JSONSerialization.data(withJSONObject: object, options: []))
    }
}

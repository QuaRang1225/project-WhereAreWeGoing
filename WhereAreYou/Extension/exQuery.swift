//
//  exQuery.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

extension Query{
    func getDocuments2<T>(as types : T.Type)async throws -> [T] where T:Decodable{
          try await getDocumentSnapshot(as:types).product
       }
       func getDocumentSnapshot<T>(as types : T.Type)async throws -> (product : [T],lastDocument:DocumentSnapshot?) where T:Decodable{
           let snapshot = try await self.getDocuments()
           
           let product = try snapshot.documents.map({document in
               try document.data(as: T.self)
           })
           return (product,snapshot.documents.last)
       }
}

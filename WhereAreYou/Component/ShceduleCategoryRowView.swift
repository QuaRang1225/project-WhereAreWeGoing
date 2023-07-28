//
//  ShceduleCategoryRowView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/28.
//

import SwiftUI

struct ShceduleCategoryRowView: View {
    let filter:LocationCategoryFilter
    var body: some View {
        VStack{
            Circle()
                .frame(width: 50,height: 50)
                .foregroundColor(.gray.opacity(0.7))
                .overlay {
                    Image(systemName: filter.image)
                        .foregroundColor(.white)
                        .font(.title2)
                        .bold()
                }
            Text(filter.name)
                .font(.caption)
        }
    }
}

struct ShceduleCategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        ShceduleCategoryRowView(filter: .history)
    }
}

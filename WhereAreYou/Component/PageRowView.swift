//
//  PageRowView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import SwiftUI
import Kingfisher

struct PageRowView: View {
    let image:String
    let title:String
    var body: some View {
        VStack{
            KFImage(URL(string:image)!)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(height:200)
            Text(title)
        }
    }
}

struct PageRowView_Previews: PreviewProvider {
    static var previews: some View {
        PageRowView(image: CustomDataSet.shared.images.first!, title: "국내")
    }
}

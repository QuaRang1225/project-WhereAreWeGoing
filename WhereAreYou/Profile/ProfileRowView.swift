//
//  ProfileRowView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/11.
//

import SwiftUI
import Kingfisher

struct ProfileRowView: View {
    let image:String
    let name:String
    var body: some View {
        HStack{
            KFImage(URL(string: image))
                .resizable()
                .scaledToFill()
                .clipShape( RoundedRectangle(cornerRadius: 20))
                .frame(width: 50,height: 50)
                .padding(.trailing,10)
                .shadow(radius: 0.5)
                
            Text(name)
                .font(.body)
                .foregroundColor(.black)
                .bold()
            
        }
    }
}

struct ProfileRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRowView(image: CustomDataSet.shared.basicImage, name: "콰랑")
    }
}

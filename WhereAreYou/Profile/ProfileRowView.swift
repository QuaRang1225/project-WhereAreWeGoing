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
                .frame(width: 50,height: 50)
                .clipShape( RoundedRectangle(cornerRadius: 20))
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
        ProfileRowView(image: "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/users%2F4KYzTqO9HthK3nnOUAyIMKcaxa03%2F0872D400-F1EE-40D0-BD92-FA9A90861E75.jpeg?alt=media&token=27c21b90-fd04-40f3-975f-8adb00efd035", name: "콰랑")
    }
}

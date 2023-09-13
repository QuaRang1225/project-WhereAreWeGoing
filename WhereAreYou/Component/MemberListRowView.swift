//
//  MemberListRowView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/09/13.
//

import SwiftUI
import Kingfisher


struct MemberListRowView: View {
    
    let image:String
    let name:String
    let admin:Bool
    
    var body: some View {
        HStack{
            KFImage(URL(string: image))
                .resizable()
                .scaledToFill()
                .frame(width: 50,height: 50)
                .clipShape( RoundedRectangle(cornerRadius: 20))
                .overlay{
                    if admin{
                        Image("crown")
                            .resizable()
                            .frame(width: 50,height: 30)
                            .rotationEffect(Angle(degrees: -20))
                            .offset(x:-15)
                            .offset(y:-25)
                    }
                    
                }
            Text(name)
                .bold()
            Spacer()
        }
    }
}

struct MemberListRowView_Previews: PreviewProvider {
    static var previews: some View {
        MemberListRowView(image: CustomDataSet.shared.images.first!, name: "ddd", admin: false)
    }
}

//
//  ProfileRowView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/11.
//

import SwiftUI
import Kingfisher

struct ProfileRowView: View {
    
//    let userid:String
    @State var user:UserData
    var body: some View {
        HStack{
            KFImage(URL(string: user.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50,height: 50)
                .clipShape( RoundedRectangle(cornerRadius: 20))
                .padding(.trailing,10)
                .shadow(radius: 0.5)
            VStack(alignment: .leading){
                Text(user.nickName ?? "")
                    .font(.body)
                    .bold()
                Text(user.email ?? "")
                    .font(.caption)
            }
            Spacer()
            NavigationLink {
                
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
                    
            }

            
            
        }
        .foregroundColor(.black).padding(.horizontal)
//        .onAppear{
//            Task{
//               user = try await UserManager.shared.getUser(userId:userid)
//            }
//        }
    }
}

//struct ProfileRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileRowView(user:UserData())
//    }
//}

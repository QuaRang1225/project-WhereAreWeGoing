//
//  ProfileRowView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/11.
//

import SwiftUI
import Kingfisher

struct ProfileRowView: View {
    
    @EnvironmentObject var vmAuth:AuthViewModel
    
    var body: some View {
        HStack{
            KFImage(URL(string: vmAuth.user?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width: 50,height: 50)
                .clipShape( RoundedRectangle(cornerRadius: 20))
                .padding(.trailing,10)
                .shadow(radius: 0.5)
            VStack(alignment: .leading){
                Text(vmAuth.user?.nickName ?? "")
                    .font(.body)
                    .bold()
                Text(vmAuth.user?.email ?? "")
                    .font(.caption)
            }
            Spacer()
            NavigationLink {
                ProfileChangeView()
                    .environmentObject(vmAuth)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
                    
            }
            
        }
        .foregroundColor(.black).padding(.horizontal)
    }
}

struct ProfileRowView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRowView()
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}

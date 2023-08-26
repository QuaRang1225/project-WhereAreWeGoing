//
//  PageRowView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import SwiftUI
import Kingfisher

struct PageRowView: View {
    let page:Page
    @State var user:UserData?
    var body: some View {
        HStack{
            KFImage(URL(string:page.pageImageUrl)!)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .frame(width: 70,height:70)
            VStack(alignment: .leading,spacing: 5){
                Text(page.pageName)
                    .font(.subheadline)
                    .bold()
                Text(page.pageSubscript)
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Spacer()
        }
//        .overlay(alignment:.topTrailing) {
//            HStack(alignment: .bottom){
//                HStack(spacing: 0) {
//                    Text("방장")
//                    Text(user?.nickName ?? "").bold()
//                    Text("님")
//                }.foregroundColor(.gray).font(.caption2)
//
//                KFImage(URL(string: user?.profileImageUrl ?? ""))
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 30,height: 30)
//                    .clipShape(Circle())
//            }
//
//        }
//        .task {
//            do{
//                user = try? await UserManager.shared.getUser(userId: page.pageAdmin)
//            }
//            catch{
//                print("에러;\(error)")
//            }
//
//
//        }
        
    }
}

struct PageRowView_Previews: PreviewProvider {
    static var previews: some View {
        PageRowView(page: CustomDataSet.shared.page())
    }
}

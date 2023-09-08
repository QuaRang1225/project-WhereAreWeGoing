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
//    @StateObject var vm = PageViewModel()
    var body: some View {
        HStack{
            KFImage(URL(string:page.pageImageUrl ?? "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/background%2Fnight.jpeg?alt=media&token=2191462b-14b8-4407-adcf-f73a7ed0b39e"))
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
        // -----------------추가 업데이트 예정 -------------------------
//        .overlay(alignment:.topTrailing) {
//            HStack(alignment: .bottom){
//                HStack(spacing: 0) {
//                    Text("방장")
//                    Text(vm.admin?.nickName ?? "").bold()
//                    Text("님")
//                }.foregroundColor(.gray).font(.caption2)
//
//                KFImage(URL(string: vm.admin?.profileImageUrl ?? ""))
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 30,height: 30)
//                    .clipShape(Circle())
//            }
//
//        }
//        .onAppear {
//            vm.getUser(userId: page.pageAdmin)
//        }
        
    }
}

struct PageRowView_Previews: PreviewProvider {
    static var previews: some View {
        PageRowView(page: CustomDataSet.shared.page())
    }
}

//
//  MemberTabView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI
import Kingfisher

struct MemberTabView: View {
    

    @EnvironmentObject var vm:PageViewModel
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            Section("방장"){
                HStack{
                    KFImage(URL(string: vm.admin?.profileImageUrl ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50,height: 50)
                        .clipShape( RoundedRectangle(cornerRadius: 20))
                        .overlay{
                            Image("crown")
                                .resizable()
                                .frame(width: 50,height: 30)
                                .rotationEffect(Angle(degrees: -20))
                                .offset(x:-15)
                                .offset(y:-25)
                        }
                    Text(vm.admin?.nickName ?? "")
                        .bold()
                    Spacer()
                }
            }
            .foregroundColor(.black.opacity(0.7))
            .padding()
            Divider()
                .padding(.horizontal)
            Section("맴버"){
                emptymember
            }
            .foregroundColor(.black.opacity(0.7))
            .padding()
        }
    }
}

struct MemberTabView_Previews: PreviewProvider {
    static var previews: some View {

        MemberTabView()
            .environmentObject(PageViewModel())
    }
}

extension MemberTabView{
    var emptymember:some View{
        HStack{
            Image(systemName: "person.fill.xmark")
            Text("아직 맴버가 없습니다.")
        }
        .foregroundColor(.gray.opacity(0.5))
    }
}

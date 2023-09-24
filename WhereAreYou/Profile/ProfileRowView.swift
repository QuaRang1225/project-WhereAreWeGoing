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
    @State var profile = false
    @State var nickname = false
    @EnvironmentObject var vmAuth:AuthViewModel
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
                VStack{
                    ZStack(alignment: .leading){
                        Image(systemName: "chevron.left")
                        Text("프로필 변경").font(.title3).frame(maxWidth: .infinity).bold()
                    }.padding(.bottom)
                    ScrollView{
                        VStack(alignment: .leading) {
                            Button {
                                profile = true
                            } label: {
                                Text("프로필 사진 변경")
                            }
                            Divider()
                            Button {
                               nickname = true
                            } label: {
                                Text("닉네임 변경")
                            }
                            Divider()
                            Text("로그아웃")
                                .foregroundColor(.red)
                            Divider()
                            Text("탈퇴하기")
                                .foregroundColor(.red)
                            Divider()
                        }
                        
                    }
                    
                }
                .foregroundColor(.black)
                .padding()
                .background(Color.white.ignoresSafeArea())
                .navigationBarBackButtonHidden()
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray.opacity(0.5))
                    
            }
            .sheet(isPresented: $nickname){
                NickNameView(text: user.nickName ?? "",modify: true)
                    .environmentObject(vmAuth)
                    .navigationBarBackButtonHidden()
            }
            .sheet(isPresented: $profile) {
                ProfileSelectView(modify: true)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
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

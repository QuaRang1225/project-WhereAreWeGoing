//
//  PageMainView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/25.
//

import SwiftUI
import Kingfisher

struct PageMainView: View {
    
    @State var admin:UserData? = nil
    var page:Page
    @State var time = Timer.publish(every: 0.1, on: .current, in: .tracking)
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topLeading){
            ScrollView(.vertical,showsIndicators: false){
                VStack{
                    ZStack(alignment: .bottomTrailing){
                        GeometryReader { pro in
                            KFImage(URL(string: page.pageImageUrl)!)
                                .resizable()
                                .overlay{
                                    Color.black.opacity(0.3)
                                }
                                .offset(y:pro.frame(in: .global).minY > 0 ? -pro.frame(in: .global).minY:0)
                                .frame(height:pro.frame(in: .global).minY > 0 ?  UIScreen.main.bounds.height/3 + pro.frame(in: .global).minY : UIScreen.main.bounds.height/3)
                        }
                        VStack(alignment: .trailing,spacing: 5){
                            HStack{
                                if page.pageOverseas{
                                    Text("🌏")
                                }else{
                                    Text("🇰🇷")
                                }
                                Text(page.pageName)
                                    .font(.title)
                                    .bold()
                            }
                            
                            Text(page.pageSubscript)
                                .font(.callout)
                        }
                        .foregroundColor(.white)
                        .padding(.trailing)
                        .offset(y:-10)
                    }
                    .frame(height: UIScreen.main.bounds.height/3)
                    VStack(alignment: .leading,spacing: 0){
                        Section("방장"){
                            HStack{
                                KFImage(URL(string: admin?.profileImageUrl ?? ""))
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
                                Text(admin?.nickName ?? "")
                                    .bold()
                                Spacer()
                            }
                        }
                        .foregroundColor(.black.opacity(0.7))
                        .padding()
                        Divider()
                            .padding(.horizontal)
                        Section("맴버"){
                        }
                        .foregroundColor(.black.opacity(0.7))
                        .padding()
                    }
                }
            }
            .foregroundColor(.black)
            .background(Color.white)
            .edgesIgnoringSafeArea(.top)
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        
                        .padding(.leading)
                        
                }.shadow(color:.black,radius: 20)
                Spacer()
                Image(systemName: "person.badge.plus")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
            VStack{
                Divider()
                    .background(Color.black)
                    .padding(.bottom)
                HStack(spacing: 0){
                    Group{
                        ForEach(1...4,id:\.self){ _ in
                            Image(systemName: "heart")
                                .foregroundColor(.red)
                        }
                    }.frame(maxWidth: .infinity)
                }
            }.frame(maxHeight: .infinity,alignment: .bottom)
            
        }
        .onAppear{
            Task{
                admin = try await UserManager.shared.getUser(userId: page.pageAdmin)
            }
        }
    }
}

struct PageMainView_Previews: PreviewProvider {
    static var previews: some View {
        PageMainView(page: Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.images.first!, pageName: "으딩이", pageOverseas: false, pageSubscript: "으딩이와 함께 하는 우리어디가"))
    }
}

enum PageTabFilter:CaseIterable{
    case map
    case text
    case member
    case setting
}

//
//  ProfileChangeView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/09/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileChangeView: View {

    
    let columns: [GridItem] = [
            GridItem(.fixed(100), spacing: nil, alignment: nil),
            GridItem(.fixed(100), spacing: nil, alignment: nil),
            GridItem(.fixed(100), spacing: nil, alignment: nil)
        ]
    
    @State var loading = false
    @State var nickname = ""
    @State var profile = ""
    @State var preProfile = ""
    @State var data:Data?
    @State var selecteItem:PhotosPickerItem?
    
    @State var logout = false
    @State var delete = false
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var vmAuth:AuthViewModel
    
    var body: some View {
        VStack{
            Text("프로필 변경").font(.title3).frame(maxWidth: .infinity).bold().padding(.bottom)
            ScrollView{
                VStack{
                LazyVGrid(columns: columns,spacing: 20){
                    ForEach(CustomDataSet.shared.images,id:\.self){ image in
                        Button {
                            selecteItem = nil
                            data = nil
                            profile = image
                            preProfile = ""
                        } label: {
                            KFImage(URL(string:image))
                                .resizable()
                                .overlay{
                                    if !profile.isEmpty || data != nil {
                                        if selecteItem != nil || profile != image{
                                            Color.white.opacity(0.8)
                                        }
                                    }
                                }
                                .frame(width: 80,height: 80)
                                .cornerRadius(30)
                        }
                    }
                    PhotosPicker(
                        selection: $selecteItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if let selectedImageData = data,
                               let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80,height: 80).clipShape(RoundedRectangle(cornerRadius: 30))
                                
                            }else{
                                if !preProfile.isEmpty{
                                    KFImage(URL(string:preProfile))
                                        .resizable()
                                        .frame(width: 80,height: 80)
                                        .cornerRadius(30)
                                }else{
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(lineWidth: 1)
                                        .frame(width: 80,height: 80)
                                        .overlay {
                                            Image(systemName: "camera")
                                                .font(.title)
                                        }
                                        .foregroundStyle(.gray)
                                }
                                
                            }
                        }
                        .onChange(of: selecteItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    self.data = data
                                }
                            }
                        }
                    
                }
                .foregroundColor(.black)
                .padding(.vertical)
                    nicknameInputView
                    SelectButton(color:.customCyan3 , textColor: .white, text: "수정"){
                        loading = true
                        if let item = selecteItem {
                            vmAuth.updatePhotoProfileImage(item: item)
                        }else if !profile.isEmpty{
                            vmAuth.updateImageProfileImage(item: profile)
                        }
                    }
                    Divider()
                        .padding(.vertical)
                    SelectButton(color: .gray.opacity(0.3), textColor: .black, text: "로그아웃") {
                        logout = true
                    }
                    .confirmationDialog("로그아웃", isPresented: $logout, actions: {
                        Button(role:.destructive){
                            vmAuth.logOut()
                        } label: {
                            Text("로그아웃")
                        }
                    },message: {
                        Text("정말 로그아웃 하시겠습니까?")
                    })
                    SelectButton(color: .red, textColor: .white, text: "탈퇴") {
                        delete = true
                    }
                    .confirmationDialog("계정 탈퇴", isPresented: $delete, actions: {
                        Button(role:.destructive){
                            guard let user = vmAuth.user else {return}
                            vmAuth.delete(user: user)
                            vmAuth.user = nil
                        } label: {
                            Text("탈퇴하기")
                        }
                    },message: {
                        Text("정말 탈퇴 하시겠습니까?")
                    })
                }
            }
        }
        .onAppear{
            print(preProfile)
        }
        .overlay{
            if loading{
                CustomProgressView(title: "계정 생성 중..").ignoresSafeArea()
            }
            
        }
        .onReceive(vmAuth.changedSuccess){
            dismiss()
        }
        .foregroundColor(.black)
        .padding()
        .background(Color.white.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        
        
    }
    var header:some View{
        Text("닉네임설정")
            .font(.title)
            .bold()
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.leading)
            .padding(.vertical,30)
            .foregroundColor(.black)
    }
    var nicknameInputView:some View{
        VStack(alignment: .leading){
            CustomTextField(placeholder: "입력..", isSecure: false, text: $nickname)
                .padding(.top,30)
            
            Text("닉네임을 설정하지 않을 시 이메일로 자동설정 되며. 이후에 변경할 수 있습니다.")
                .foregroundColor(.gray)
                .font(.caption)
                .padding(.bottom)
        }
        .padding(.horizontal)
    }
}

struct ProfileChangeView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileChangeView()
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}

//
//  AddScheduleView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/28.
//

import SwiftUI
import PhotosUI

struct AddScheduleView: View {
    
    @State var title = ""
    @State var text = ""
    @State var locationSelect:LocationCategoryFilter = .cafe
    @EnvironmentObject var vm:PageViewModel
    @Binding var isPage:Bool
    var body: some View {
        VStack{
            header
            ScrollView(showsIndicators: false){
                VStack{
                    photoPicker
                    Text("사진첨부")
                        .bold()
                    Text("사진추가는 선태사항입니다.")
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.caption)
                }
                HStack{
                    Text("종류")
                        .bold()
                    Spacer()
                    Picker("", selection: $locationSelect){
                        ForEach(LocationCategoryFilter.allCases,id: \.self) { catefory in
                            ShceduleCategoryRowView(filter: catefory)
                                .padding(.horizontal)
                        }
                    }
                    .accentColor(.black)
                }
                .padding(.leading)
                HStack{
                    Text("제목")
                        .bold()
                        .padding(.trailing)
                    Spacer()
                    CustomTextField(placeholder: "일정의 제목을 입력해주세요", isSecure: false, color: .black, text: $title)
                }
                .padding(.leading)
                
                TextEditor(text: $text)
                    .frame(height: 500)
                    .border(Color.gray, width: 3)
                    .overlay(alignment:.topLeading){
                        if text.isEmpty{
                            Text("일정을 자세히 적어주세요")
                                .padding(7)
                                .allowsHitTesting(false)
                        }
                    }
                    .environment(\.colorScheme, .light)
                    .padding()
                
            }
        }
        .background{
            Color.white.ignoresSafeArea()
        }
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView(isPage: .constant(true))
            .environmentObject(PageViewModel())
    }
}
extension AddScheduleView{
    var header:some View{
        ZStack(alignment: .top){
            Text("일정 작성")
                .font(.title3)
                .bold()
            VStack{
                HStack{
                    Button {
                        isPage = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .bold()
                            .padding(.leading)
                        
                    }.shadow(color:.black,radius: 20)
                    Spacer()
                    if !text.isEmpty,!title.isEmpty{
                        Button {
                            isPage = false
                        } label: {
                            Text("작성")
                        }
                        .padding(.trailing)
                        .bold()
                    }
                }
                
            }
            
        }
        .foregroundColor(.black)
        
    }
    var photoPicker:some View{
        PhotosPicker(
            selection: $vm.selection,
            matching: .images,
            photoLibrary: .shared()) {
                if let selectedImageData = vm.data,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    
                }else{
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 3)
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(systemName: "camera")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 30,height: 30)
                        }
                        .foregroundColor(.black)
                }
            }.onChange(of: vm.selection) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        vm.data = data
                    }
                }
            }
            .padding(.top)
    }
}

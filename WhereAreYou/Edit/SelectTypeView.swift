//
//  SelectTypeView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/21.
//

import SwiftUI
import PhotosUI

struct SelectTypeView: View {
    
    @State var title = ""
    @State var text = ""
    
    @State var selection:PhotosPickerItem? = nil
    @State var data:Data? = nil
    @State var overseas:Bool? = nil
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            VStack(spacing:10){
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.black)
                    }
                    .padding()
                    Spacer()
                    Text("완료")
                        .padding()
                }
                ScrollView{
                    Text("어디로 여행하세요?")
                        .font(.title)
                        .bold()
                        .padding(.bottom,10)
                    Text("방제목, 소개글, 사진 등을 선택해 주세요")
                        .foregroundColor(.gray)
                        .padding(.bottom)
                    PhotosPicker(
                        selection: $selection,
                           matching: .images,
                           photoLibrary: .shared()) {
                               if let selectedImageData = data,
                                  let uiImage = UIImage(data: selectedImageData) {
                                   Image(uiImage: uiImage)
                                       .resizable()
                                       .scaledToFill()
                                       .clipShape(Circle())
                                       .frame(width: 120, height: 120)
                               }else{
                                   RoundedRectangle(cornerRadius: 50)
                                       .stroke(lineWidth: 3)
                                       .frame(width: 120, height: 120)
                                       .overlay {
                                           Image(systemName: "camera")
                                               .resizable()
                                               .scaledToFill()
                                               .frame(width: 30,height: 30)
                                       }
                                       .foregroundColor(.black)
                               }
                           }.onChange(of: selection) { newItem in
                               Task {
                                   if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                       self.data = data
                                   }
                               }
                           }
                    CustomTextField(placeholder: "제목..", isSecure: false,color: .black, text: $title)
                        .padding(.horizontal,100)
                    CustomTextField(placeholder: "소개글을 작성해주세요..", isSecure: false,color: .black, text: $text)
                        .padding()
                    
                    HStack{
                        Group{
                            Button {
                                overseas = true
                            } label: {
                                Image("korean")
                                    .resizable()
                                    .frame(width: 120,height: 120)
                                    .overlay {
                                        Circle()
                                            .frame(width: 120,height: 120)
                                            .foregroundColor(overseas ?? false ? .black.opacity(0.3) : .white)
                                    }
                                
                            }
                            Button {
                                overseas = false
                            } label: {
                                Image("over")
                                    .resizable()
                                    .frame(width: 150,height: 140)
                                    .overlay {
                                        Circle()
                                            .frame(width: 150,height: 140)
                                            .foregroundColor(overseas ?? true ? .white : .black.opacity(0.3))
                                    }
                            }
                            
                        }
                        .padding()
                        .foregroundColor(.white)
                        .frame(height: 200)
                        .shadow(radius: 5)
                    }
                    .padding()
                    Spacer()
                }
                
                }
                
        }
    }
}

struct SelectTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTypeView()
    }
}

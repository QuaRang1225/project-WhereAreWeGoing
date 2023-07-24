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
    
    @State var overseas:Bool? = nil
    @StateObject var vm = EditViewModel()
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
                    if overseas != nil && !text.isEmpty && !title.isEmpty{
                        Button {
                            
                        } label: {
                            Text("완료")
                                .padding()
                                .foregroundColor(.black)
                        }
                    }else{
                        Text("완료")
                            .padding()
                            .foregroundColor(.gray)
                    }
                    
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
                        selection: $vm.selection,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if let selectedImageData = vm.data,
                               let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(RoundedRectangle(cornerRadius: 50))
                                
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
                        }.onChange(of: vm.selection) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    vm.data = data
                                }
                            }
                        }
                        .padding(.bottom)
                    CustomTextField(placeholder: "제목..", isSecure: false,color: .black, text: $title)
                        .padding(.horizontal,100)
                    CustomTextField(placeholder: "소개글을 작성해주세요..", isSecure: false,color: .black, text: $text)
                        .padding()
                    
                    HStack{
                        Group{
                            VStack{
                                Button {
                                    overseas = true
                                } label: {
                                    Image("korean")
                                        .resizable()
                                        .frame(width: 120,height: 120)
                                        .overlay {
                                            Circle()
                                                .frame(width: 120,height: 120)
                                                .foregroundColor(overseas ?? false ? .black.opacity(0.3) : .clear)
                                        }
                                    
                                }
                                
                                Text("국내")
                                
                            }
                            VStack{
                                Button {
                                    overseas = false
                                } label: {
                                    Image("over")
                                        .resizable()
                                        .frame(width: 120,height: 120)
                                        .overlay {
                                            Circle()
                                                .frame(width: 120,height: 120)
                                                .foregroundColor(overseas ?? true ? .clear : .black.opacity(0.3))
                                        }
                                }
                                Text("해외")
                            }
                            
                            
                        }
                        .padding()
                        .bold()
                        .frame(height: 200)
                        .shadow(radius: 5)
                    }
                    .padding()
                    Spacer()
                }
                
            }
            
            
        }.foregroundColor(.black)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
    }
}

struct SelectTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTypeView()
    }
}

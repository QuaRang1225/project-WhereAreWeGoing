//
//  SearchView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/11.
//

import SwiftUI

struct SearchView: View {
    @State var text = ""
    @State var noResult:Bool?
    @State var pages:[Page] = []
    @State var page:Page?
    @Environment(\.dismiss)var dismiss
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack{
                Text("페이지검색")
                    .foregroundColor(.black)
                    .padding(.bottom)
                    .bold()
                CustomTextField(placeholder: "페이지명 혹은 페이지ID를 입력해주세요..", isSecure: false, text: $text)
                Spacer()
                SelectButton(color: !text.isEmpty ? .customCyan:.customCyan2.opacity(0.5), textColor:.white, text: "검색") {
                    Task{
                        guard !text.isEmpty else {return}
                        pages = try await UserManager.shared.getSearchPage(text: text)
                        noResult = pages == [] ? true : false
                    }
                }
                ScrollView{
                    
                        if let noResult{
                            if noResult{
                                Text("검색결과가 없습니다..").font(.subheadline)
                            }else{
                                ForEach(pages,id: \.self){ page in
                                    VStack{
                                        Button {
                                            self.page = page
                                            UIApplication.shared.endEditing()
                                        } label: {
                                            PageRowView(page: page)
                                                .padding()
                                        }
                                           
                                        Divider()
                                    }
                                }
                            }
                        }
                    }
               
            
            }
            
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .padding(.leading)
                    .bold()
            }
            if page != nil{
                RequestPageView(page: $page)
                    .padding()
                    .frame(maxHeight: .infinity)
                    .environmentObject(vm)
                    .environmentObject(vmAuth)
                
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .foregroundColor(.black)
        .background{
            Color.white.ignoresSafeArea()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(PageViewModel(page: nil, pages: CustomDataSet.shared.pages()))
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}

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
    
    @Environment(\.dismiss)var dismiss
    @StateObject var vm = PageViewModel(page: nil, pages: [])
    @EnvironmentObject var vmAuth:AuthViewModel
    
    var body: some View {
        ZStack(alignment: .topLeading){
            VStack{
                Text("페이지검색")
                    .foregroundColor(.black)
                    .padding(.bottom)
                    .bold()
                CustomTextField(placeholder: "페이지명 혹은 페이지ID를 입력해주세요..", isSecure: false, text: $text)
                    .padding(.horizontal)
                Spacer()
                SelectButton(color: !text.isEmpty ? .customCyan:.gray, textColor:.white, text: "검색") {
                    Task{
                        guard !text.isEmpty else {return}
                        vm.pages = try await UserManager.shared.getSearchPage(text: text)
                        noResult = vm.pages.isEmpty ? true : false
                    }
                }
                ScrollView{
                    
                        if let noResult{
                            if noResult{
                                Text("검색결과가 없습니다..").font(.subheadline)
                            }else{
                                ForEach(vm.pages,id: \.self){ page in
                                    VStack{
                                        Button {
                                            vm.page = page
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
           
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .foregroundColor(.black)
        .background{
            Color.white.ignoresSafeArea()
        }
        .sheet(isPresented: Binding(
            get: { vm.page != nil },
            set: { if !$0 { vm.page = nil } }
        )) {
            RequestPageView()
                .environmentObject(vm)
                .environmentObject(vmAuth)
                .presentationDetents([.fraction(0.7)])
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

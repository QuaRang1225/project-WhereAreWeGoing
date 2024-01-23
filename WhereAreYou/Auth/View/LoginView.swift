//
//  LoginView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
   
    @State var email = ""
    @State var password = ""
    @State var mailStatus:EmailAddress = .gmail
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm:AuthViewModel
    @FocusState private var focus:FormField?
    
    var body: some View {
        VStack(spacing: 25){
           header
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading) {
                    emailInputView
                    passwordInputView
                    SelectButton(color: .customCyan, textColor: .white, text: "로그인") {
                        Task{
                            try await vm.signIn(email: "\(email)@\(mailStatus.name)", password: password)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onSubmit {
            switch focus {
            case .email:
                focus = .password
            default:
                focus = nil
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            LoginView()
                .environmentObject(AuthViewModel())
        }
    }
}

extension LoginView{
    var header:some View{
        HStack{
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
            }
            Text("로그인하기")
                
        }
        .foregroundStyle(.black)
        .font(.title)
        .bold()
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.leading)
        .padding(.bottom,30)
    }
    var emailInputView:some View{
        VStack(alignment: .leading){
            Text("이메일")
                .bold()
                .padding(.leading)
            HStack{
                CustomTextField(placeholder: "입력..", isSecure: false,text: $email)
                    .textContentType(.emailAddress)
                    .disableAutocorrection(true)
                    .submitLabel(.next)
                    .focused($focus, equals:FormField.email)
                    .padding(.leading)
                Text("@")
                Picker("", selection: $mailStatus) {
                    ForEach(EmailAddress.allCases,id: \.self){
                        Text($0.name)
                    }
                }
                .accentColor(.black)
            }
        }
    }
    var passwordInputView:some View{
        VStack(alignment: .leading){
            Text("비밀번호")
                .bold()
                .padding(.leading)
            CustomTextField(placeholder: "입력..", isSecure: true, text: $password)
                .textContentType(.password)
                .submitLabel(.done)
                .focused($focus, equals:FormField.password)
                .padding(.horizontal)
        }
        .overlay(alignment: .bottomLeading) {
            Text(vm.errorString)
                .font(.caption)
                .padding(.leading)
                .offset(y:25)
                .foregroundColor(.red)
        }
        .padding(.bottom)
    }
}

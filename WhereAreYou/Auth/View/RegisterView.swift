//
//  RegisterView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct RegisterView: View {
    
    @State var email = ""
    @State var password = ""
    @State var passwordConfirm = ""
    
    @State var mailStatus:EmailAddress = .gmail
    
    @FocusState private var focus:FormField?
    @EnvironmentObject var vm:AuthViewModel
    
    var body: some View {
        VStack(spacing: 5){
            header
            ScrollView(showsIndicators: false){
                VStack{
                    emailInputView
                    passwordInputView
                    passwordConfirmInputView
                    registerButton
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onSubmit {
            switch focus {
            case .email:
                focus = .password
            case .password:
                focus = .passwordConfirm
            default:
                focus = nil
            }
        }
        .onTapGesture { //이거 넣으면 탭뷰 터치 안됨
            UIApplication.shared.endEditing()
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environment(\.colorScheme,.light)
            .environmentObject(AuthViewModel())
    }
}

extension RegisterView{
    var header:some View{
        Text("회원가입하기")
        .foregroundStyle(.black)
        .font(.title)
        .bold()
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding(.leading)
        .padding(.vertical,30)
    }
    var emailInputView:some View{
        VStack(alignment: .leading) {
            Text("이메일")
                .bold()
                .padding(.leading)
                .padding(.bottom,5)
            HStack{
                CustomTextField(placeholder: "입력..", isSecure: false, text: $email)
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
            }.padding(.bottom)
        }
    }
    var passwordInputView:some View{
        VStack(alignment: .leading) {
            Text("비밀번호")
                .bold()
                .padding(.leading)
                .padding(.bottom,5)
            CustomTextField(placeholder: "입력..", isSecure: true,  text: $password)
                .textContentType(.password)
                .submitLabel(.next)
                .focused($focus, equals:FormField.password)
                .padding(.bottom)
                .padding(.horizontal)
        }
    }
    var passwordConfirmInputView:some View{
        VStack(alignment: .leading) {
            Text("비밀번호 확인")
                .bold()
                .padding(.leading)
                .padding(.bottom,5)
                
            CustomTextField(placeholder: "입력..", isSecure: true,  text: $passwordConfirm)
                .textContentType(.password)
                .submitLabel(.done)
                .focused($focus, equals:FormField.passwordConfirm)
                .padding(.horizontal)
                .overlay(alignment: .bottomLeading) {
                    Text(vm.errorString)
                        .font(.caption)
                        .padding(.leading)
                        .offset(y:20)
                        .foregroundColor(.red)
                }
                .padding(.bottom)
            
        }
    }
    var registerButton:some View{
        VStack(alignment: .leading){
            SelectButton(color: .customCyan, textColor: .white, text: "회원가입") {
                guard password != passwordConfirm else { return  vm.errorString = "비밀번호가 일치하지 않습니다." }
                Task{
                    try await vm.signUp(email: "\(email)@\(mailStatus.name)", password: password)
                }
            }
            .padding(.top)
            Text("비밀번호는 8~20자 사이 대,소문자와 숫자, !_@$%^&+= 등의 기호를 사용할수 있습니다.")
                .font(.caption2)
                .foregroundColor(.gray)
                .padding(.leading)
                .padding(.bottom)
        }
    }
}

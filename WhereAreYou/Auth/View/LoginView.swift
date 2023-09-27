//
//  LoginView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var error = false
    @State var isRegister = false
    @State var email = ""
    @State var password = ""
    @State var mailStatus:EmailAddress = .gmail
    @EnvironmentObject var vm:AuthViewModel
    @FocusState private var focus:FormField?
    
    var body: some View {
        VStack(spacing: 25){
            Text("로그인하기")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading)
                .padding(.bottom,30)
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading) {
                    Text("이메일")
                        .bold()
                        .padding(.leading)
                    HStack{
                        CustomTextField(placeholder: "입력..", isSecure: false, color: .customCyan, text: $email)
                            .textContentType(.emailAddress)
                            .disableAutocorrection(true)
                            .submitLabel(.next)
                            .focused($focus, equals:FormField.email)
                        Text("@")
                        Picker("", selection: $mailStatus) {
                            ForEach(EmailAddress.allCases,id: \.self){
                                Text($0.name)
                            }
                        }
                        .accentColor(.black)
                    }
                    Text("비밀번호")
                        .bold()
                        .padding(.leading)
                    CustomTextField(placeholder: "입력..", isSecure: true,color: .customCyan, text: $password)
                        .textContentType(.password)
                        .submitLabel(.done)
                        .focused($focus, equals:FormField.password)
                    SelectButton(color: .customCyan, textColor: .white, text: "로그인") {
                        Task{
                            try await vm.signIn(email: "\(email)@\(mailStatus.name)", password: password)
                        }
                    }
                    .padding(.vertical)
                    Group{
                        HStack{
                            Spacer()
                            Group{
                                Text("비밀번호 찾기").fixedSize(horizontal: true, vertical: false)
                                Text("|")
                                Text("아이디 찾기")
                                Text("|")
                                Button {
                                    isRegister = true
                                } label: {
                                    Text("회원가입")
                                }
                            }.font(.caption2)
                            .frame(maxWidth: .infinity)
                            
                        }
                        .padding(.horizontal,30)
                    }
                }
            }
        }
        .onChange(of: vm.errorString){ _ in
            error = true
        }
        .alert(isPresented: $error){
            Alert(title:Text("알림") ,message: Text(vm.errorString),dismissButton:.none)
        }
        .background{
            AuthBackground()
        }
        .foregroundColor(.black)
        .onSubmit {
            switch focus {
            case .email:
                focus = .password
            default:
                focus = nil
            }
        }
        .fullScreenCover(isPresented: $isRegister) {
            RegisterView().navigationBarBackButtonHidden()
                .environmentObject(vm)
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



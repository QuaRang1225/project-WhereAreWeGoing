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
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: 25){
            Text("회원가입하기")
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
                        CustomTextField(placeholder: "입력..", isSecure: false, text: $email)
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
                    CustomTextField(placeholder: "입력..", isSecure: true, text: $password)
                        .textContentType(.password)
                        .submitLabel(.next)
                        .focused($focus, equals:FormField.password)
                    Text("비밀번호 확인")
                        .bold()
                        .padding(.leading)
                    CustomTextField(placeholder: "입력..", isSecure: true, text: $passwordConfirm)
                        .textContentType(.password)
                        .submitLabel(.done)
                        .focused($focus, equals:FormField.passwordConfirm)
                    SelectButton(color: .customYellow, textColor: .white, text: "회원가입") {
                        
                    }
                    .padding(.vertical)
                    HStack{
                        Button(action: {
                            dismiss()
                        }, label: {
                            HStack(spacing: 3){
                                Text("계정이 있으신가요?")
                                Text("로그인")
                                    .bold()
                            }
                        })
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                    }
                    .padding(.horizontal,30)
                }
            }
        }
        .background{
            AuthBackground()
        }
        .foregroundColor(.black)
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
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}

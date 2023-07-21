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
    @State var authCheck:ErrorAuthFilter? = nil
    @State var mailStatus:EmailAddress = .gmail
    
    @FocusState private var focus:FormField?
    @Environment(\.dismiss)var dismiss
    @EnvironmentObject var vm:AuthViewModel
    
    var body: some View {
        VStack(spacing: 5){
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
                        .padding(.bottom,5)
                    HStack{
                        CustomTextField(placeholder: "입력..", isSecure: false,color: .customCyan, text: $email)
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
                    }.padding(.bottom)
                    Text("비밀번호")
                        .bold()
                        .padding(.leading)
                        .padding(.bottom,5)
                    CustomTextField(placeholder: "입력..", isSecure: true, color: .customCyan, text: $password)
                        .textContentType(.password)
                        .submitLabel(.next)
                        .focused($focus, equals:FormField.password)
                        .padding(.bottom)
                    Text("비밀번호 확인")
                        .bold()
                        .padding(.leading)
                        .padding(.bottom,5)
                    CustomTextField(placeholder: "입력..", isSecure: true, color: .customCyan, text: $passwordConfirm)
                        .textContentType(.password)
                        .submitLabel(.done)
                        .focused($focus, equals:FormField.passwordConfirm)
                    Text("비밀번호는 8~20자 사이 대,소문자와 숫자, !_@$%^&+= 등의 기호를 사용할수 있습니다.")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.leading)
                        .padding(.bottom)
                    if let check = authCheck{
                        Text(check.phraseText)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                    SelectButton(color: .customCyan, textColor: .white, text: "회원가입") {
                        self.authCheck = invaildAuth()
                        if authCheck == .SUCCESS{
                            Task{
                                do{
                                    try await vm.signUp(email: "\(email)@\(mailStatus.name)", password: password)
                                }catch{
                                    print("에러명 " + error.localizedDescription)
                                }
                            }
                        }
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
        .onTapGesture { //이거 넣으면 탭뷰 터치 안됨
            UIApplication.shared.endEditing()
        }
    }
    func invaildAuth() -> ErrorAuthFilter{
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let pwdRegex = "[A-Za-z0-9!_@$%^&+=]{8,20}"
        let emailRegexPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let passwordRegexPredicate = NSPredicate(format: "SELF MATCHES %@", pwdRegex)


        if !email.isEmpty && !password.isEmpty && !passwordConfirm.isEmpty{
            if password == passwordConfirm{
                if !emailRegexPredicate.evaluate(with: "\(email)@\(mailStatus.name)"){
                    return .INVAILD_EMAIL
                }else if !passwordRegexPredicate.evaluate(with: password) && passwordRegexPredicate.evaluate(with: passwordConfirm){
                    return .INVAILD_PWD
                }
                else{
                    return .SUCCESS
                }
            }
            else{
                return .MISMATCH_PWD
            }
        }
        else{
            return .EMPTY_DATA
        }
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(AuthViewModel())
    }
}


enum ErrorAuthFilter{
    case EMPTY_DATA
    case INVAILD_EMAIL
    case INVAILD_PWD
    case MISMATCH_PWD
    case SUCCESS
    
    var phraseText:String{
        switch self{
        case .EMPTY_DATA:
            return "입력하지 않은정보가 있습니다!"
        case .INVAILD_EMAIL:
            return "이메일 형식이 유효하지 않습니다!"
        case .INVAILD_PWD:
            return "비밀번호 형식이 유효하지 않습니다!"
        case .MISMATCH_PWD:
            return "비밀번호가 일치하지 않습니다!"
        case .SUCCESS:
            return ""
        }
    
    }
}

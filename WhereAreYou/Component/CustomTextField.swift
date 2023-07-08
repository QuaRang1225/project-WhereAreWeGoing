//
//  CustomTextField.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder:String
    let isSecure:Bool
    @Binding var text:String
    var body: some View {
        VStack{
            HStack{
                if !isSecure{
                    TextField("",text: $text)
                        .overlay(alignment:.leading) {
                            if text.isEmpty{
                                Text(placeholder)
                                    .foregroundColor(.gray)
                            }
                        }
                }else{
                    SecureField("",text: $text)
                        .overlay(alignment:.leading) {
                            if text.isEmpty{
                                Text(placeholder)
                                    .foregroundColor(.gray)
                            }
                        }
                }
                if !text.isEmpty{
                    Button {
                        text = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            Divider()
                .frame(height: 3)
                .overlay(Color.customYellow)
        }
        .padding(.horizontal)
        .foregroundColor(.black)
       
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: "입력..", isSecure: false, text: .constant(""))
    }
}

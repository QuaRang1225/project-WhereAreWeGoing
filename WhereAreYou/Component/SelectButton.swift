//
//  SelectButton.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct SelectButton: View {
    let color:Color
    let textColor:Color
    let text:String
    let action:()->Void
    var body: some View {
        Button {
            action()
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 40)
                .foregroundColor(color)
                .overlay {
                    Text(text)
                        .bold()
                        .font(.subheadline)
                        .foregroundColor(textColor)
                }
                .padding(.horizontal)
        }

        
        
    }
}

struct SelectButton_Previews: PreviewProvider {
    static var previews: some View {
        SelectButton(color: .customCyan, textColor: .white, text: "확인", action: {})
    }
}

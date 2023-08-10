//
//  CustomProgressView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//

import SwiftUI

struct CustomProgressView: View {
    let title:String
    var body: some View {
        ZStack{
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack{
                ProgressView()
                    .padding(.bottom,5)
                    .environment(\.colorScheme, .light)
                Text(title)
                    .font(.caption)
            }
            .background{
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 150,height: 100)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
            }
        }
        
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView(title: "페이지 생성중..")
    }
}

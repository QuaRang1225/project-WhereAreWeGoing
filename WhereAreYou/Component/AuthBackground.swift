//
//  AuthBackground.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct AuthBackground: View {
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            VStack{
                Color.customCyan
                    .ignoresSafeArea()
                    .frame(height: 200)
                    .overlay {
                        Image("road")
                            .offset(x:-60)
                    }
                    .overlay(alignment: .topTrailing, content: {
                        Image("kidsblue")
                            .offset(y:-90)
                    })
                    .frame(maxHeight: .infinity,alignment: .bottom)
            }.ignoresSafeArea()
        }
        
    }
}

struct AuthBackground_Previews: PreviewProvider {
    static var previews: some View {
        AuthBackground()
    }
}

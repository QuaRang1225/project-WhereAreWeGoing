//
//  StartView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct StartView: View {
    @State var isStart = false
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            if isStart{
                VStack{
                    Image("where")
                        .resizable()
                        .frame(width: 150,height: 150)
                    Text("우리 어디가?")
                        .foregroundColor(.customCyan)
                        .fontWeight(.black)
                }
                
            }
            Image("kids")
                .frame(maxWidth: .infinity,alignment: .trailing)
                .frame(maxHeight: .infinity,alignment: .bottom)
                .padding()
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                withAnimation(.easeIn(duration: 0.5)){
                    isStart = true
                }
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}

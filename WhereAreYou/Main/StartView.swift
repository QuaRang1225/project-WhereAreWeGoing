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
            Color.customYellow.ignoresSafeArea()
            if isStart{
                Image("title")
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

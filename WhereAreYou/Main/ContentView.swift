//
//  ContentView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct ContentView: View {
    

    @State var isStart = false
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            if !isStart{
                StartView()
            }else{
                NavigationStack{
//                    LoginView()
                    MainView()
                }
               
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                withAnimation(.easeIn(duration: 0.5)){
                    isStart = true
                }
            }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

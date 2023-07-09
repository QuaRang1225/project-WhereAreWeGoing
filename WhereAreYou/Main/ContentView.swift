//
//  ContentView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/01.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var vm = AuthViewModel()
    @State var isStart = false
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            if !isStart{
                StartView()
            }else{
                if vm.user != nil{
                    TabBarView()
                }else{
                    LoginView()
                        .environmentObject(vm)
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                withAnimation(.easeIn(duration: 0.5)){
                    isStart = true
                }
            }
            if let auth = try? AuthManager.shared.getUser(){    //자동로그인
                vm.user = UserData(auth: auth)
            }
        }
        .onTapGesture { //이거 넣으면 탭뷰가 이상해여~
            UIApplication.shared.endEditing()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

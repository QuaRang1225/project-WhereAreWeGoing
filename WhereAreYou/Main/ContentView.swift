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
                if let user = vm.user{
                    if user.guestMode{
                        InfoSettingTabView()
                            .environmentObject(vm)
                    }else{
                        NavigationStack{
                            MainView()
                                .environmentObject(vm)
                        }
                    }
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
            guard let auth = try? AuthManager.shared.getUser() else { return }  //자동로그인
            vm.getUser(auth: auth)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  TabBarView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/02.
//

import SwiftUI


struct TabBarView: View {
    
    init(){
        changeColorTabBar()
    }
 
    @State var selection:Menu = .home
    @EnvironmentObject var vm:AuthViewModel
    var body: some View {
        TabView(selection: $selection) {
            MainView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(Menu.home)
                .environmentObject(vm)
            Text("ads")
                .tabItem {
                    Image(systemName: "message")
                    Text("채팅")
                }
                .tag(Menu.home)
            Text("ads")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("설정")
                }
                .tag(Menu.home)
        }
        .accentColor(.black)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
            .environmentObject(AuthViewModel())
    }
}

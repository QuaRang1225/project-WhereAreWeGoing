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
    var body: some View {
        TabView(selection: $selection) {
            MainView()
                .tag(Menu.home)
                .tabItem {
                    Image(systemName: "house")
                }
            MainView()
                .tag(Menu.chat)
                .tabItem {
                    Image(systemName: "message")
                }
            MainView()
                .tag(Menu.setting)
                .tabItem {
                    Image(systemName: "gearshape")
                }
        }
        .accentColor(.black)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

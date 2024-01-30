//
//  InfoSelectTabView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/10.
//

import SwiftUI

struct InfoSettingTabView: View {
    
    @EnvironmentObject var vm:AuthViewModel
    
    var body: some View {
        TabView(selection: $vm.infoSetting) {
            NickNameView()
                .tag(InfoSettingFilter.nickname)
                .environmentObject(vm)
            ProfileSelectView()
                .tag(InfoSettingFilter.profile)
                .environmentObject(vm)
        }
        .tabViewStyle(.page)
        .onAppear{
            vm.infoSetting = .nickname
        }
        
    }
}

struct InfoSelectTabView_Previews: PreviewProvider {
    static var previews: some View {
        InfoSettingTabView()
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}

enum InfoSettingFilter{
    case nickname
    case profile
}

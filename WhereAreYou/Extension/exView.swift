//
//  exView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/02.
//

import Foundation
import SwiftUI

extension View{
    func changeColorTabBar(){
        // UITabBarAppearance 설정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white // 원하는 배경색으로 변경
        
        // TabView의 모든 탭바에 적용
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

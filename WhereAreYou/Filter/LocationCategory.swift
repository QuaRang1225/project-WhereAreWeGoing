//
//  LocationCategory.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/28.
//

import Foundation

enum LocationCategoryFilter:CaseIterable{
    case cafe
    case restaurant
    case museum
    case park
    case active
    case hotel
    case traffic
    case market
    case airport
    case history
    case other
    
    var image:String{
        switch self{
        case .cafe:
            return "cup.and.saucer.fill"
        case .restaurant:
            return "fork.knife"
        case .museum:
            return "theatermask.and.paintbrush.fill"
        case .park:
            return "leaf.fill"
        case .active:
            return "party.popper.fill"
        case .hotel:
            return "bed.double.fill"
        case .traffic:
            return "bus"
        case .market:
            return "cart.fill"
        case .airport:
            return "airplane"
        case .history:
            return "building.columns.fill"
        case .other:
            return "flag.2.crossed.fill"
        }
    }
    var name:String{
        switch self{
        case .cafe:
            return "카페/휴식"
        case .restaurant:
            return "식당"
        case .museum:
            return "박물관/테마파크"
        case .park:
            return "자연"
        case .active:
            return "활동/놀이"
        case .hotel:
            return "숙박"
        case .traffic:
            return "교통"
        case .market:
            return "시장/마트"
        case .airport:
            return "공항"
        case .history:
            return "종교/유적"
        case .other:
            return "기타"
        }
    }
}

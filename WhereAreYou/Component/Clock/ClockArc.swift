//
//  ClockArc.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//
//
//import SwiftUI
//
//struct ClockArc: View {
//    var startAngle: Angle
//    var endAngle: Angle
//    
//    var body: some View {
//        Circle()
//            .trim(from: CGFloat(startAngle.degrees / 360), to: CGFloat(endAngle.degrees / 360))
//            .stroke(Color.customCyan2, lineWidth: 10)
//            .rotationEffect(.degrees(-90))
//    }
//}
//
//struct ClockArc_Previews: PreviewProvider {
//    static var previews: some View {
//        ClockArc(startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 80))
//    }
//}

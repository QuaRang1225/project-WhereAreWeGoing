//
//  HourMarker.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//
//
//import SwiftUI
//
//struct HourMarker: View {
//    var angle: Angle
//    var hour:Int
//    
//    var body: some View {
//        ZStack{
//            Rectangle()
//                .fill(Color.gray)
//                .frame(width: 2, height: 10)
//                .offset(y: -120)
//                .rotationEffect(angle, anchor: .center)
//            Text("\(hour)시")
//                .rotationEffect(-angle)
//                .offset(y: -150)
//                .rotationEffect(angle, anchor: .center)
//                .font(.caption)
//                .bold()
//                
//        }
//        
//    }
//}
//
//struct HourMarker_Previews: PreviewProvider {
//    static var previews: some View {
//        HourMarker(angle: Angle(degrees: 120), hour: 16)
//    }
//}

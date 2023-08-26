//
//  SchduleListView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI

struct SchduleListView: View {
    @Binding var page:Page
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var vm:PageViewModel
    @State var date = 0
    
    @State var startTime:Date? = nil
    @State var endTime:Date? = nil

   var body: some View {
       ZStack{
           VStack {
               datePicker
              
               
               
               
               
               
               Spacer()
//               if vm.schedules.isEmpty{
//                   emptyView
//               }else{
//                   scheduleList
//               }
           scheduleList
           }
       }
       .padding()
       .onAppear{
           if let user = vmAuth.user{
               vm.getSchedule(user: user, pageId: page.pageId)
           }
       }
       
   }
    func angleForTime(_ date: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        let totalMinutes = Double(components.hour!) * 60 + Double(components.minute!)
        let angle = (totalMinutes / (24 * 60)) * 360
        return angle
    }
       
}

struct SchduleListView_Previews: PreviewProvider {
    static var previews: some View {
        SchduleListView(page: .constant(CustomDataSet.shared.page()))
            .environmentObject(PageViewModel())
            .environmentObject(AuthViewModel())
            .background(Color.white.ignoresSafeArea())
    }
}

extension SchduleListView{
    var datePicker:some View{
        Picker("", selection: $date) {
            ForEach(Array(page.dateRange.enumerated()),id: \.0){ (index,page) in
                Text("\(index + 1)일차")
            }
        }
        .pickerStyle(.segmented)
        .padding()
        .environment(\.colorScheme, .light)
    }
    var emptyView:some View{
        VStack(spacing: 10){
            Image(systemName: "text.badge.xmark")
            Text("아직 일정이 없습니다.")
                .font(.title3)
        }
        .bold()
        .foregroundColor(.gray)
        .font(.largeTitle)
        .opacity(0.3)
        .frame(maxHeight: .infinity,alignment: .center)
    }
    var scheduleList:some View{
        VStack {
//            Text("일정표")
//                .font(.title)
//                .bold()

//            ZStack {
//
//                Circle()
//                    .stroke(Color.black, lineWidth: 2)
//                    .frame(width: 250, height: 250)
//
//                ForEach(1...24, id: \.self) { hour in
//                    let angle = Double(hour) * 360 / 24
//                    HourMarker(angle: .degrees(angle),hour: hour)
//                }
//
//                ClockArc(startAngle: angleForTime(startTime ?? Date()) , endAngle: angleForTime(endTime ?? Date()))
//                Circle()
//                    .foregroundColor(.black)
//                    .frame(width: 10,height: 10)
//            }
//            .frame(width: 250, height: 250)
//            .padding(.vertical,50)

            ForEach(vm.schedules,id: \.self){ schedule in
                Button {
                    startTime = schedule.startTime.toDateTime()
                    endTime = schedule.endTime.toDateTime()
                } label: {
                    ScheduleRowView(schedule: schedule)
                }

            }
            .padding(.bottom,100)
        }
    }
}





//struct ClockHand: View {
//
//    var angle: Angle
//    var color: Color
//
//    var body: some View {
//        Rectangle()
//            .fill(color)
//            .frame(width: 3, height: 100)
//            .offset(y: -45)
//            .rotationEffect(angle, anchor: .center)
//    }
//}



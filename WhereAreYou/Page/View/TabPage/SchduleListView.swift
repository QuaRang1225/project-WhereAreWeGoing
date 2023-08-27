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
    @State var binding:Schedule?

   var body: some View {
       ZStack{
           VStack {
               datePicker
               Spacer()
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
        VStack(spacing: 0){
            ForEach(vm.schedules,id: \.self){ schedule in
                HStack{
                    Circle()
                        .frame(width: 20,height: 20)
                        .overlay{
                            Circle()
                                .frame(width: 10,height: 10)
                                .foregroundColor(.white)
                        }
                        .foregroundColor(.customCyan2)
                        
                    Button {
                        withAnimation {
                            self.binding = schedule
                        }
                    } label: {
                        VStack{
                            ScheduleRowView(schedule: schedule,binding: schedule == binding ?  .constant(true) : .constant(false)).padding(.top,5)
                            Divider()
                        }
                        
                    }
                }
                
            }
            .background(alignment: .leading){
                Rectangle()
                    .frame(width: 4)
                    .foregroundColor(.customCyan2)
                    .padding(.leading,7.5)
            }
        }
    }
}


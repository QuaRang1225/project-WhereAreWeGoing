//
//  SchduleListView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI
import Kingfisher
import FirebaseFirestore


struct SchduleListView: View {
//    @Binding var page:Page
    
    @StateObject var location = LocationMagager()
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var vm:PageViewModel
    
    @State var isSearch = false
//    @State var time = Timestamp()
    @State var date = 0
    @State var select:Schedule?
    @State var rowButton:Bool?
//    @Binding var photo:Bool
    
    
    
    var days:[Schedule]{
        let calendar = Calendar.current
        return vm.schedules.filter({calendar.isDate($0.startTime.dateValue(), equalTo: vm.page?.dateRange[date].dateValue() ?? Date(), toGranularity: .day) || calendar.isDate($0.endTime.dateValue(), equalTo: vm.page?.dateRange[date].dateValue() ?? Date(), toGranularity: .day)}).sorted{$0.startTime < $1.startTime}
    }
    var body: some View {
        ZStack{
            VStack {
                
                
                datePicker
                HStack(spacing: 0){
                    HStack{
                        Text("\(date + 1)일차 : ").font(.caption).bold()
                        Text("\(vm.page?.dateRange[date].dateValue().toStringCalender() ?? "")")
                            .font(.caption)
                        .foregroundColor(.black)
                        .bold()
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 1)
                        
                        Spacer()
                        Button {
                            isSearch = true
                        } label: {
                            HStack(spacing: 2){
                                Image(systemName: "plus.app.fill").font(.body)
                                Text("일정 추가")
                            }
                            .font(.caption)
                            .foregroundColor(.black)
                            .bold()
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(radius: 1)
                        }
                        .padding()
                    }.padding(.leading)
                    
                }
                if days.isEmpty{
                    emptyView
                }else{
                    scheduleList
                }
                Spacer()
            }
            
        }
        .padding()
        .navigationDestination(isPresented: $isSearch){
            SearchAddressView(geo: nil, isSearch: $isSearch)
                .environmentObject(vm)
                .environmentObject(vmAuth)
                .environmentObject(location)
                .navigationBarBackButtonHidden()
        }
       

    }
    
}

struct SchduleListView_Previews: PreviewProvider {
    static var previews: some View {
        SchduleListView()
            .environmentObject(PageViewModel())
            .environmentObject(AuthViewModel())
            .background(Color.white.ignoresSafeArea())
    }
}

extension SchduleListView{
    var datePicker:some View{
        Picker("", selection: $date) {
            if let dateRange = vm.page?.dateRange{
                ForEach(Array(dateRange.enumerated()),id: \.0){ (index,page) in
                    Text("\(index + 1)일차")
                }
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
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
            ForEach(Array(days.enumerated()),id: \.0){ (index,schedule) in
                HStack{
                    Circle()
                        .frame(width: 20,height: 20)
                        .overlay{
                            ZStack{
                                Circle()
                                    .frame(width: 10,height: 10)
                                    .foregroundColor(.white)
                                if vm.isCurrentDateInRange(startDate: schedule.startTime.dateValue(), endDate: schedule.endTime.dateValue()){
                                    Text("⏰")
                                        .font(.title)
                                        .frame(width: 50,height: 50)
                                }
                            }
                        }
                        .foregroundColor(.customCyan2)
                    Button {
                        withAnimation {
                            guard let select = self.select else { return self.select = schedule }
                            self.select = select == schedule ? nil : schedule
                        }
                    } label: {
                        VStack{
                            ScheduleRowView(schedule: schedule, num:index + 1, binding: self.select == schedule ? .constant(true) : .constant(false)).padding(.top,5)
                                .environmentObject(vm)
                                .environmentObject(vmAuth)
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


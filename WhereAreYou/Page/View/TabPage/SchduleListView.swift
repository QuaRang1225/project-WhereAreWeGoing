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
    @Binding var page:Page
    
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var vm:PageViewModel
    
    @State var isSearch = false
    @State var time = Timestamp()
    @State var date = 0
    
    @Binding var binding:Schedule?
    @Binding var photo:Bool
    
    
    
    var days:[Schedule]{
        let calendar = Calendar.current
        return vm.schedules.filter({calendar.isDate($0.startTime.dateValue(), equalTo: page.dateRange[date].dateValue(), toGranularity: .day) || calendar.isDate($0.endTime.dateValue(), equalTo: page.dateRange[date].dateValue(), toGranularity: .day)}).sorted{$0.startTime < $1.startTime}
    }
    var body: some View {
        ZStack{
            VStack {
                
                
                datePicker
                HStack(spacing: 0){
                    HStack{
                        Text("\(date + 1)일차 : ").font(.caption).bold()
                        Text("\(time.dateValue().toStringCalender())")
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
            SearchAddressView(isSearch: $isSearch)
                .environmentObject(vm)
                .environmentObject(vmAuth)
                .navigationBarBackButtonHidden()
        }
        .onAppear{
            if let user = vmAuth.user{
                vm.getSchedule(user: user, pageId: page.pageId)
            }
            time = page.dateRange[date]
        }
        .onChange(of: date) { newValue in
            time = page.dateRange[date]
        }
    }
    
}

struct SchduleListView_Previews: PreviewProvider {
    static var previews: some View {
        SchduleListView(page: .constant(CustomDataSet.shared.page()),binding: .constant(CustomDataSet.shared.schedule()),photo: .constant(false))
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
            
            ForEach(days,id: \.self){ schedule in
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
                            if binding == schedule{
                                self.binding = nil
                            }else{
                                self.binding = schedule
                            }
                            
                        }
                    } label: {
                        VStack{
                            ScheduleRowView(schedule: schedule,scheduleBinding: $binding,binding: schedule == binding ?  .constant(true) : .constant(false),photo: $photo).padding(.top,5)
                                .environmentObject(vm)
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


//
//  CalenderView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/29.
//

import SwiftUI
import UIKit
import FSCalendar
import FirebaseFirestore

struct CalenderView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var vm:PageViewModel
    var body: some View {
        VStack{
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .padding(.leading)
                
                Spacer()
            }
            .overlay {
                HStack(spacing:3){
                    Image("calender")
                        .resizable()
                        .frame(width: 25,height: 25)
                    Text("내 일정")
                        .bold()
                }
                
            }
            .padding(.bottom)
            Divider()
            
            CustomCalendarView()
                .padding()
                .padding(.top)
                .padding(.bottom,50)
                .environmentObject(vm)
            
        }
        .foregroundColor(.black)
        .background(Color.white)
    }
}

struct CalenderView_Previews: PreviewProvider {
    static var previews: some View {
        CalenderView()
            .environmentObject(PageViewModel())
    }
}

struct CustomCalendarView: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    @EnvironmentObject var vm: PageViewModel
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(vm: vm)
    }
    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        calendar.locale = Locale(identifier: "ko_FR")
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.appearance.headerTitleColor = UIColor(Color.black)
        calendar.appearance.headerTitleAlignment = .center
        calendar.headerHeight = 45
        calendar.appearance.weekdayTextColor = UIColor(Color.customCyan2)
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendar.appearance.subtitleDefaultColor = UIColor.black
        calendar.appearance.eventDefaultColor = UIColor(Color.customCyan2)
        calendar.appearance.eventSelectionColor = UIColor(Color.customCyan2)
        calendar.appearance.subtitleSelectionColor =  UIColor.white
        calendar.appearance.selectionColor = UIColor(Color.gray.opacity(0.3))
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {}
    
    
    
    class Coordinator: NSObject, FSCalendarDelegate, FSCalendarDataSource {
        
        var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        var vm: PageViewModel
        
        init(vm: PageViewModel) {
            self.vm = vm
        }
        
        @MainActor func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
            var name = ""
            for page in vm.pages{
                for dates in page.dateRange{
                    guard let eventDat = dateFormatter.date(from: dates.dateValue().toStringCalender()) else {return ""}
                    if date.compare(eventDat) == .orderedSame{
                        name.append(contentsOf: page.pageName)
                    }
                }
            }
            return name
        }
        @MainActor func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            var num = 0
            for page in vm.pages{
                for dates in page.dateRange{
                    guard let eventDat = dateFormatter.date(from: dates.dateValue().toStringCalender()) else {return 0}
                    if date.compare(eventDat) == .orderedSame{
                        num += 1
                    }
                }
            }
            return num
        }
        @MainActor func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            
            let dateRange = vm.pages.map({$0.dateRange.map({$0.dateValue().toStringCalender()})})
            for dates in dateRange{
                if dates.contains(dateFormatter.string(from: date)){
                    vm.page = vm.pages.first(where:{$0.dateRange.contains(Timestamp.init(date: date))})
//                    print("\(vm.page) 날짜가 선택되었습니다.")
                }
            }
        }
       @MainActor func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
            
            for page in vm.pages{
                for dates in page.dateRange{
                    guard let eventDat = dateFormatter.date(from: dates.dateValue().toStringCalender()) else {return UIImage(named: "")}
                    if date.compare(eventDat) == .orderedSame{
                        return UIImage(named: "travel")?.resize(newWidth: 30)
                    }
                }
            }
           return UIImage(named: "")
        }
    }
}


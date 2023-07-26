//
//  SchduleListView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI

struct SchduleListView: View {
    @Binding var page:Page
    @EnvironmentObject var vm:PageViewModel
    @State var date = 0

       var body: some View {
           ZStack{
               VStack {
                  datePicker
                   emptyView
               }
               
           }
           .padding()
           
       }

       
}

struct SchduleListView_Previews: PreviewProvider {
    static var previews: some View {
        SchduleListView(page: .constant(CustomDataSet.shared.page()))
            .environmentObject(PageViewModel())
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
        .frame(maxHeight: .infinity,alignment:.top)
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
}




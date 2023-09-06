//
//  CalenderView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/29.
//

import SwiftUI
import Kingfisher

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
                .environmentObject(vm)
                .frame(height: UIScreen.main.bounds.height - 300)
            
            RoundedRectangle(cornerRadius: 20)
                .frame(height: 100)
                .padding(.horizontal)
                .foregroundColor(.white)
                .shadow(radius: 10)
                .overlay {
                    HStack{
                        if let page = vm.page{
                            KFImage(URL(string: page.pageImageUrl ?? ""))
                                .resizable()
                                .frame(width: 80, height: 80)
                                .cornerRadius(20)
                                .padding(.leading,30)
                            VStack(alignment: .leading){
                                Text(page.pageName)
                                    .bold()
                                Text(page.pageSubscript)
                                    .foregroundColor(.gray)
                                    .font(.caption)
                               
                            }
                            Spacer()
                        }else{
                            Image(systemName: "text.badge.xmark").foregroundColor(.gray).font(.title3)
                            Text("일정 없음").foregroundColor(.gray).bold()
                        }
                    }
                }
            Spacer()
            
        }
        .onChange(of: vm.page, perform: { newValue in
            print(newValue)
        })
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




//
//  ScheduleRowView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/08/09.
//

import SwiftUI
import Kingfisher
import CoreLocation

struct ScheduleRowView: View {
    
    let schedule:Schedule
    let num:Int
    
    @State var goWebView = false
    @State var link = ""
    @State var delete = false
    @Binding var scheduleBinding:Schedule?
    @Binding var binding:Bool
    @Binding var photo:Bool
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    
    @State var modify = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .bottom){
                Button {
                    scheduleBinding = schedule
                    if schedule.imageUrl != nil || schedule.imageUrl != ""{
                        photo = true
                    }
                } label: {
                    KFImage(URL(string: schedule.imageUrl ?? ""))
                        .placeholder { _ in
                            placeholder
                        }
                        .resizable()
                        .frame(width:100,height: 100)
                        .cornerRadius(20)
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text("\(num). \(schedule.title)")
                        .bold()
                        .font(.body)
                        .padding(.bottom,2)
                    HStack{
                        ForEach(LocationCategoryFilter.allCases,id: \.self){ filter in
                            if filter.name == schedule.category{
                                Image(systemName: filter.image)
                            }
                        }
                        Text(schedule.category)
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom,5)
                    
                    Text("일정 시작 : \(schedule.startTime.dateValue().toTimeString())")
                    Text("일정 끝 : \(schedule.endTime.dateValue().toTimeString())")
                    
                }
            }
            if binding{
                HStack(alignment:.top){
                    VStack(alignment:.leading){

                        HStack(alignment:.top){
                            NavigationLink {
                                ScheduleMapView(schedule: schedule)
                                    .environmentObject(vm)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                HStack(spacing:3){
                                    Image("where")
                                        .resizable()
                                        .frame(width: 10,height: 15)
                                    Text("지도로 보기")
                                    Image(systemName: "chevron.right")
                                }
                                    .foregroundColor(.black)
                            }
                            
                            
                        }.font(.caption)//.padding(.bottom,5)
                    }
                    Spacer()
                    Group{
                        Button {
                            modify = true
                            vm.modifingSchecdule = schedule
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .padding(7.5)
                                .background(Circle().foregroundColor(.white))
                                .shadow(radius: 1)
                                .font(.subheadline)
                                
                        }
                        .navigationDestination(isPresented: $modify) {
                            SearchAddressView(geo: schedule.location, isSearch: $modify)
                                .navigationBarBackButtonHidden()
                                .environmentObject(vmAuth)
                                .environmentObject(vm)
                        }
                        Button {
                            delete = true
                        } label: {
                            Image(systemName: "trash")
                                .padding(7.5)
                                .background(Circle().foregroundColor(.white))
                                .shadow(radius: 1)
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }

                        
                    }.foregroundColor(.gray)
                }
                
                
                VStack(alignment: .leading){
                    Text("내용")
                        .font(.body)
                        .bold()
                        .padding(.bottom,5)
                    Text("\(schedule.content)".replacingOccurrences(of: "\\n", with: "\n"))
                    if let links = schedule.link,links != [:]{
                        HStack(spacing: 1){
                            Image(systemName: "link").font(.caption)
                            Text("링크")
                        }
                        .font(.subheadline)
                        .padding(.top).bold()
                        
                        ForEach(Array(links),id: \.0){ (key,value) in
                            Button {
                                goWebView = true
                                link = value
                            } label: {
                                HStack(spacing:0){
                                    Text("\(key) :")
                                    Text(value)
                                       .lineLimit(1).underline()
                                } .foregroundColor(.gray).font(.caption)
                                
                            }

                        }
                        .padding(.top,2)
                    }
                    
                }
               
                    .frame(maxWidth: .infinity,alignment:.leading)
                    .padding(10)
                    .padding(.vertical)
                    .multilineTextAlignment(.leading).font(.subheadline)
                    .background(Color.gray.opacity(0.1))
                
            }
            
        }
        .confirmationDialog("일정 삭제", isPresented: $delete, actions: {
            Button(role:.destructive){
                if let user = vmAuth.user,let page = vm.page{
                    vm.deleteSchedule(user: user, pageId: page.pageId, schedule: schedule)
                }
            } label: {
                Text("삭제")
            }
        },message: {
            Text("\(schedule.title) 일정을 삭제하시겠습니까?").bold()
        })

        .sheet(isPresented: $goWebView) {
            LinkWebView(urlString: link).ignoresSafeArea()
        }
    }
    
    
}

struct ScheduleRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            ScheduleRowView(schedule: CustomDataSet.shared.schedule(), num:1,scheduleBinding: .constant(CustomDataSet.shared.schedule()),binding: .constant(true),photo: .constant(false)).environmentObject(PageViewModel()).environmentObject(AuthViewModel())
        }
    }
}

extension ScheduleRowView{
    var placeholder:some View{
        RoundedRectangle(cornerRadius: 20)
            .foregroundColor(.gray.opacity(0.3))
            .frame(width: 100,height: 100)
            .overlay {
                ZStack{
                    VStack{
                        Image(systemName: "photo")
                            .font(.title)
                            .padding(.bottom,2)
                        Text("사진 없음")
                    }
                    .foregroundColor(.gray)
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 5)
                        .frame(width: 100,height:100)
                        .foregroundColor(.white)
                    
                }
                
            }
    }
}

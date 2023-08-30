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
    @Binding var binding:Bool
    @EnvironmentObject var vm:PageViewModel
    @StateObject var location = LocationMagager()
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .bottom){
                KFImage(URL(string: schedule.imageUrl ?? ""))
                    .placeholder { _ in
                        placeholder
                    }
                    .resizable()
                    .frame(width:100,height: 100)
                    .cornerRadius(20)
                Spacer()
                VStack(alignment: .trailing){
                    Text(schedule.title)
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
                
                
                Button {
                    vm.copyToPasteboard(text: "\(location.pickedPlaceMark?.administrativeArea != location.pickedPlaceMark?.locality ? location.pickedPlaceMark?.locality ?? "": "") \(location.pickedPlaceMark?.thoroughfare ?? "") \(location.pickedPlaceMark?.subThoroughfare ?? "")")
                } label: {
                    HStack(spacing: 2){
                        Text("주소: ").bold()
                        HStack{
                            if location.pickedPlaceMark?.administrativeArea != location.pickedPlaceMark?.locality{
                                Text(location.pickedPlaceMark?.locality ?? "")
                            }   //서울특별시
                            Text(location.pickedPlaceMark?.thoroughfare ?? "")
                            Text(location.pickedPlaceMark?.subThoroughfare ?? "")
                        }
                        Image(systemName: "link")
                    }.foregroundColor(.gray).font(.caption)
                }

                NavigationLink {
                    ScheduleMapView(schedule: schedule)
                        .environmentObject(vm)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing:2){
                        Image("where")
                            .resizable()
                            .frame(width: 15,height: 20)
                        Text("지도로 보기")
                        Image(systemName: "chevron.right")
                    }.font(.subheadline)
                        .foregroundColor(.black)
                }
                .padding(.bottom,5)
                VStack(alignment: .leading){
                    Text("내용")
                        .font(.body)
                        .bold()
                        .padding(.bottom,5)
                    Text("\(schedule.content)".replacingOccurrences(of: "\\n", with: "\n"))
                }
               
                    .frame(maxWidth: .infinity,alignment:.leading)
                    .padding(10)
                    .padding(.vertical)
                    .multilineTextAlignment(.leading).font(.subheadline)
                    .background(Color.gray.opacity(0.1))
                
            }
            
        }
        
        .onAppear{
            location.updatePlacemark(location: CLLocation(latitude: schedule.location.latitude, longitude: schedule.location.longitude))
        }
        
    }
    
    
}

struct ScheduleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRowView(schedule: CustomDataSet.shared.schedule(),binding: .constant(true)).environmentObject(PageViewModel())
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

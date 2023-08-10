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
    @StateObject var location = LocationMagager()
    var body: some View {
            VStack(alignment: .leading){
                HStack{
                   
                    Spacer()
                    
                    
                }
                
                HStack(alignment: .bottom){
                    KFImage(URL(string: schedule.imageUrl ?? ""))
                        .placeholder { _ in
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.gray.opacity(0.3))
                                .frame(width: 150,height: 150)
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
                                            .frame(width: 130,height: 130)
                                            .foregroundColor(.white)
                                            
                                    }
                                    
                                }
                        }
                        .resizable()
                        .frame(width: 150,height: 150)
                        .cornerRadius(20)
                    Spacer()
                    VStack(alignment: .trailing){
                        Text(schedule.title)
                            .bold()
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
                        .padding(.bottom)
                        HStack(spacing: 2){
                            if location.pickedPlaceMark?.administrativeArea != location.pickedPlaceMark?.locality{
                                Text(location.pickedPlaceMark?.locality ?? "")
                            }   //서울특별시
                            Text(location.pickedPlaceMark?.thoroughfare ?? "")
                            Text(location.pickedPlaceMark?.subThoroughfare ?? "")
                        }
                        
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom,5)
                        Text("일정 시작 : \(schedule.startTime)")
                        Text("일정 끝 : \(schedule.endTime)")
                        
                    }
                }
            }
            .onAppear{
                location.updatePlacemark(location: CLLocation(latitude: schedule.location.latitude, longitude: schedule.location.longitude))
            }
            
        }
        
    
}

struct ScheduleRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleRowView(schedule: CustomDataSet.shared.schedule())
    }
}

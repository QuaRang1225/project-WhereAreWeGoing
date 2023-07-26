//
//  AddScheduleView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/26.
//

import SwiftUI
import MapKit

struct AddScheduleView: View {
    
    @State var text = ""
    @State var city:[String] = []
    @State var country:[String] = []
    @State var fetchPlace:[CLPlacemark]?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            header
            VStack{
                if let place = fetchPlace{
                    ForEach(place,id: \.self){ name in
                        Text("\(convertLocationToAddress(location:name.location ?? CLLocation()).0)")
                        Text("\(convertLocationToAddress(location:name.location ?? CLLocation()).1)")
                    }
                    
                }
            }
        }
        
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            AddScheduleView()
        }
    }
}

extension AddScheduleView{
    var header:some View{
        ZStack(alignment: .top){
            Text("주소 검색")
                .font(.title3)
                .bold()
            VStack{
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .bold()
                            
                            .padding(.leading)
                            
                    }.shadow(color:.black,radius: 20)
                    Spacer()
                              
                }
                search
                    .padding(.top,30)
                
            }
            
        }
        .foregroundColor(.black)
        .frame(maxHeight: .infinity,alignment: .top)
        
    }
    var search:some View{
        VStack(alignment: .leading){
            HStack{
                CustomTextField(placeholder: "지번,도로명으로 검색..", isSecure: false, color: .gray.opacity(0.8), text: $text)
                Button {
                    fetchPlaces(value: text)
                } label: {
                    Text("검색")
                }
                .padding(.trailing)
            }
            NavigationLink {
                
            } label: {
                HStack{
                    Image(systemName: "location.fill")
                    Text("현재 위치로")
                }
                
            }
            .padding(.leading)
            .padding(.top,10)

        }
    }
    func fetchPlaces(value:String){
        Task{
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = value.lowercased()
            let response = try? await MKLocalSearch(request: request).start()
            await MainActor.run(body: {
                for _ in 0..<10{
                    self.fetchPlace = response?.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                }
            })
        }
    }
    func convertLocationToAddress(location: CLLocation) -> (String,String){
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "ko")
            var country = ""
            var city = ""
        
            geocoder.reverseGeocodeLocation(location,preferredLocale: locale) { placemarks, error in
                guard error == nil else{ return }

                guard let placemark = placemarks?.first else { return }
                country = "\(placemark.country ?? "")"
                city = "\(placemark.locality ?? "") \(placemark.name ?? "")"
                
                
            }
        return (country,city)
    }

}


//
//  AddScheduleView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/28.
//

import SwiftUI
import PhotosUI
import Kingfisher
import FirebaseFirestore

struct AddScheduleView: View {
    
    @State var settingEndDate = false
    @State var title = ""
    @State var text = ""
    @State var progress = false
    @State var locationSelect:LocationCategoryFilter = .cafe
    @State var dateSelection = 0
    @State var linksArr:[String:String] = [:]
    @State var links:[String] = []
    @State var linktitles:[String] = []
    
    
    @State var startDate = Date()
    @State var endDate = Date()
    
    
    @State var scheduleImage = CustomDataSet.shared.placeImage.first!
    @State var data:Data? = nil
    @State var selection:PhotosPickerItem? = nil
    
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var location:LocationMagager
    
    
    var body: some View {
        ZStack{
            VStack{
               header
                ScrollView(showsIndicators: false){
                    VStack{
                        VStack(alignment: .leading){
                            locationView
                             photoPicker
                             category
                            setTitle
                             timePicker
                             addlink
                             textEditorView
                        }
                        .padding()
                        selectionButton
                        
                    }
                   
                    
                }
            }
            if progress{
                CustomProgressView(title: vm.schedule != nil ?  "일정 변경 중.." : "일정 추가 중.." )
            }
        }
        .foregroundColor(.black)
        .background{
            Color.white.ignoresSafeArea()
        }
        
        .onAppear{
            modifyModeSchedule()
            
        }
        
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView()
            .environmentObject(PageViewModel(page: nil, pages: CustomDataSet.shared.pages()))
            .environmentObject(LocationMagager())
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
    }
}
extension AddScheduleView{
    var header:some View{
        Capsule()
            .frame(width: 100,height: 5)
            .opacity(0.3)
            .padding(.vertical)
            .onTapGesture {
                    UIApplication.shared.endEditing()
            }
    }
    var locationView:some View{
        VStack{
            HStack{
                Text(location.pickedPlaceMark?.country ?? "")
                    .font(.title3)
                Text(location.pickedPlaceMark?.administrativeArea ?? "")
                Spacer()
                Button {
                    vm.copyToPasteboard(text: "\(location.pickedPlaceMark?.thoroughfare ?? "") \(location.pickedPlaceMark?.subThoroughfare ?? "")")
                } label: {
                    HStack{
                        Text("주소 복사")
                        Image(systemName: "square.on.square")
                    }
                    .foregroundColor(.gray)
                    .font(.caption)
                }
            }
            HStack(spacing: 2){
                if location.pickedPlaceMark?.administrativeArea != location.pickedPlaceMark?.locality{
                    Text(location.pickedPlaceMark?.locality ?? "")
                }   //서울특별시
                Text(location.pickedPlaceMark?.thoroughfare ?? "")
                Text(location.pickedPlaceMark?.subThoroughfare ?? "")
                Spacer()
                Text("우편번호 :")
                Text(location.pickedPlaceMark?.postalCode ?? "---")
                    .foregroundColor(.black)
                    .bold()
            }
            .font(.callout)
            .foregroundColor(.gray)
            .padding(.bottom)
        }
        .bold()
        .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
    
    var photoPicker:some View{
        VStack(alignment: .leading){
            Text("사진 선택")
                .font(.title3)
                .bold()
            Group{
                if let selectedImageData = data,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                }else{
                    KFImage(URL(string: scheduleImage))
                        .resizable()
                        .placeholder{
                            Color.gray.opacity(0.2)
                        }
                }
            }
            .frame(height: 300)
            .clipped()
            .cornerRadius(10)
            ScrollView(.horizontal) {
                HStack{
                    PhotosPicker(
                        selection: $selection,
                        matching: .images,
                        photoLibrary: .shared()) {
                            if let selectedImageData = data,
                               let uiImage = UIImage(data: selectedImageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            }else{
                                emptyImage
                            }
                        }
                    ForEach(CustomDataSet.shared.placeImage,id: \.self){ image in
                        Button{
                            data = nil
                            selection = nil
                            scheduleImage = image
                        }label: {
                            KFImage(URL(string: image))
                                .resizable()
                                .placeholder{
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 100,height: 100)
                                .cornerRadius(10)
                        }
                        
                    }
                }
            }
            .onChange(of: selection) { newItem in
                Task {
                    guard let data = try? await newItem?.loadTransferable(type: Data.self) else { return }
                    self.data = data
                    self.scheduleImage.removeAll()
                }
            }
        }
        .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
    var timePicker:some View{
        VStack{
            if settingEndDate{
                HStack{
                    DatePicker("일정 시작", selection: $startDate,in:((vm.page?.dateRange.first?.dateValue() ?? Date())...(vm.page?.dateRange.last?.dateValue().toTomorrow() ?? Date()))).environment(\.locale, .init(identifier: "ko_KR"))
                    Text("부터")
                }
                HStack{
                    DatePicker("일정 끝", selection: $endDate,in:(startDate...(vm.page?.dateRange.last?.dateValue().toTomorrow() ?? Date())))
                        .environment(\.locale, .init(identifier: "ko_KR"))
                    Text("까지")
                }
            }
        }
        .bold()
        .environment(\.colorScheme, .light)
    }
    var category:some View{
        HStack{
            Text("종류")
                .bold()
            Spacer()
            Picker("", selection: $locationSelect){
                ForEach(LocationCategoryFilter.allCases,id: \.self) { catefory in
                    ShceduleCategoryRowView(filter: catefory)
                        .padding(.horizontal)
                }
            }
            .accentColor(.black)
        }
        .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
    var setTitle:some View{
        HStack{
            Text("제목")
                .bold()
                .padding(.trailing)
            CustomTextField(placeholder: "일정의 제목을 입력해주세요", isSecure: false, text: $title)
            
        }
        .padding(.bottom,10)
        .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
    var addlink:some View{
        VStack{
            HStack(spacing: 5){
                
                Button {
                    links.append("")
                    linktitles.append("")
                } label: {
                    HStack{
                        Text("링크추가")
                            .bold()
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
            }
            ForEach(0..<links.count, id: \.self) { index in
                VStack(alignment: .leading){
                    HStack{
                        Button {
                            linksArr.removeValue(forKey: linktitles[index])
                            linktitles.remove(at: index)
                            links.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                        }
                        
                        TextField("링크 이름을 입력해주세요.",text: $linktitles[index])
                            .padding(.vertical,3).environment(\.colorScheme, .light)
                    }
                    CustomTextField(placeholder: "링크", isSecure: false,  text: $links[index])
                }
            }
        }
        .onTapGesture {
                UIApplication.shared.endEditing()
        }
    }
    var emptyImage:some View{
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 3)
            .frame(width: 100, height: 100)
            .overlay {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30,height: 30)
            }
            .foregroundColor(.black)
            .padding(2)
            .onTapGesture {
                    UIApplication.shared.endEditing()
            }
    }
    func modifyModeSchedule(){
        startDate = (vm.page?.dateRange.first?.dateValue() ?? Date())
        endDate = (vm.page?.dateRange.last?.dateValue() ?? Date())
        settingEndDate = true
        if let schedule = vm.schedule{
            title = schedule.title
            text = schedule.content.replacingOccurrences(of: "\\n", with: "\n")
            locationSelect = LocationCategoryFilter.allCases.first(where: {$0.name == schedule.category}) ?? .other
            startDate = schedule.startTime.dateValue()
            endDate = schedule.endTime.dateValue()
            linksArr = schedule.link ?? [:]
            
            for (key,value) in linksArr{
                linktitles.append(key)
                links.append(value)
            }
        }
    }
    var textEditorView:some View{
        TextEditor(text: $text)
            .frame(height: 500)
            .border(Color.black, width: 3)
            .overlay(alignment:.topLeading){
                if text.isEmpty{
                    Text("일정을 자세히 적어주세요")
                        .padding(7)
                        .foregroundColor(.gray)
                        .allowsHitTesting(false)
                }
            }
            .environment(\.colorScheme, .light)
            .padding(.vertical)
    }
    var selectionButton:some View{
        SelectButton(color: !text.isEmpty && !title.isEmpty ? .customCyan3 : .gray, textColor:.white, text: vm.page != nil ? "변경" : "완료") {
            guard !text.isEmpty && !title.isEmpty  else { return }
            
            progress = true
            for index in 0..<min(links.count, linktitles.count) {
                if !links[index].isEmpty{
                    linksArr[linktitles[index].isEmpty ? "링크\(index)" : linktitles[index]] = links[index]
                }else{
                    linksArr.removeValue(forKey: linktitles[index])
                }
            }
            guard let user = vmAuth.user,let page = vm.page else { return }
            
            let schedule = Schedule(id:vm.schedule?.id ?? "",imageUrl:vm.schedule?.imageUrl,imageUrlPath: vm.schedule?.imageUrlPath , category: locationSelect.name, title: title, startTime: startDate.toTimestamp(), endTime: endDate.toTimestamp(), content: text.replacingOccurrences(of: "\n", with: "\\n"), location: GeoPoint(latitude: (location.pickedPlaceMark?.location?.coordinate.latitude)!, longitude: (location.pickedPlaceMark?.location?.coordinate.longitude)!),link: linksArr)
            
            if vm.schedule != nil{
                vm.updateSchedule(user: user, pageId: page.pageId, schedule: schedule, item: selection, image: scheduleImage)
            }else{
                vm.creagteShcedule(user: user, pageId: page.pageId, schedule: schedule,item: selection,image:scheduleImage)
            }
        }
    }
}


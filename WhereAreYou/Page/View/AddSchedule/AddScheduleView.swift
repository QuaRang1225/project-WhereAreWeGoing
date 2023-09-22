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
    
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var location:LocationMagager
    @Binding var isPage:Bool
    
    var body: some View {
        ZStack{
            VStack{
                header
                ScrollView(showsIndicators: false){
                    VStack{
                        photoPicker
                        Text("사진첨부")
                            .bold()
                            .padding(.bottom,5)
                        Text("사진추가는 선태사항입니다.")
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.caption)
                    }
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
                    .padding(.leading)
                    HStack{
                        Text("제목")
                            .bold()
                            .padding(.trailing)
                        CustomTextField(placeholder: "일정의 제목을 입력해주세요", isSecure: false, color: .black, text: $title)
                    }
                    .padding(.leading)
                    .padding(.bottom,10)
                    
                    timePicker
                    addlink
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
                        .padding()
                    
                }
            }
            if progress{
                CustomProgressView(title: vm.schedule != nil ?  "일정 변경 중.." : "일정 추가 중.." )
            }
        }
        .onReceive(vm.addDismiss) {
            isPage = false
        }
        .foregroundColor(.black)
        .background{
            Color.white.ignoresSafeArea()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear{
            modifyModeSchedule()
        }
        .onDisappear{
            vm.data = nil
            vm.selection = nil
        }
    }
}

struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView(isPage: .constant(true))
            .environmentObject(PageViewModel())
            .environmentObject(LocationMagager())
            .environmentObject(AuthViewModel())
    }
}
extension AddScheduleView{
    var header:some View{
        ZStack(alignment: .top){
            Text(vm.schedule != nil ? "일정 변경" : "일정 작성")
                .font(.title3)
                .bold()
            VStack{
                HStack{
                    Button {
                        isPage = false
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .bold()
                            .padding(.leading)
                        
                    }.shadow(color:.black,radius: 20)
                    Spacer()
                    if !text.isEmpty,!title.isEmpty,startDate != endDate{
                        Button {
                            progress = true
                            for index in 0..<min(links.count, linktitles.count) {
                                linksArr[linktitles[index]] = links[index]
                                
                            }
                            if let user  = vmAuth.user,let page = vm.page{
                                let schedule = Schedule(id:vm.schedule?.id ?? "",creatorImage: user.profileImageUrl ?? "",creatorName: user.nickName ?? "",imageUrl:vm.schedule?.imageUrl,imageUrlPath: vm.schedule?.imageUrlPath , category: locationSelect.name, title: title, startTime: startDate.toTimestamp(), endTime: endDate.toTimestamp(), content: text.replacingOccurrences(of: "\n", with: "\\n"), location: GeoPoint(latitude: (location.pickedPlaceMark?.location?.coordinate.latitude)!, longitude: (location.pickedPlaceMark?.location?.coordinate.longitude)!),link: linksArr)
                                if vm.schedule != nil{
                                    vm.updateSchedule(user: user, pageId: page.pageId, schedule: schedule)
                                }else{
                                    vm.creagteShcedule(user: user, pageId: page.pageId, schedule: schedule)
                                }
                            }
                        } label: {
                            Text(vm.schedule != nil ? "변경" : "작성" )
                        }
                        .padding(.trailing)
                        .bold()
                    }
                }
                
            }
            
        }
        .foregroundColor(.black)
        
    }
    var photoPicker:some View{
        PhotosPicker(
            selection: $vm.selection,
            matching: .images,
            photoLibrary: .shared()) {
                if let selectedImageData = vm.data,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                }else{
                    if let image = vm.schedule?.imageUrl{
                        KFImage(URL(string: image))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    else{
                        emptyImage
                    }
                }
            }
            .overlay(alignment:.topTrailing,content: {
                if vm.data != nil || vm.schedule?.imageUrl != nil{
                    Button {
                        vm.data = nil
                        vm.schedule?.imageUrl = nil
                        vm.schedule?.imageUrlPath = nil
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                            .padding(5)
                            .background{
                                Circle().foregroundColor(.gray)
                            }
                    }
                    .offset(x:5,y:-5)
                    
                }
                
            }).onChange(of: vm.selection) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        vm.data = data
                        
                    }
                }
            }
            .padding(.top)
    }
    var timePicker:some View{
        VStack{
            
            HStack{
                DatePicker("일정 시작", selection: $startDate,in:((vm.page?.dateRange.first?.dateValue() ?? Date())...(vm.page?.dateRange.last?.dateValue() ?? Date()))).environment(\.locale, .init(identifier: "ko_KR"))
                Text("부터")
            }
            HStack{
                DatePicker("일정 끝", selection: $endDate,in:(startDate...(vm.page?.dateRange.last?.dateValue().toTomorrow() ?? Date())))
                    .environment(\.locale, .init(identifier: "ko_KR"))
                Text("까지")
            }
        }
        .bold()
        .padding(.horizontal)
        .environment(\.colorScheme, .light)
    }
    var addlink:some View{
        VStack{
            HStack(spacing: 0){
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
                    TextField("링크명",text: $linktitles[index])
                        .padding(.vertical,3).environment(\.colorScheme, .light)
                    HStack(spacing: 0) {
                        Image(systemName: "link")
                        CustomTextField(placeholder: "링크\(index + 1)", isSecure: false, color: .gray, text: $links[index])
                    }
                }
            }
        }
        .font(.subheadline)
        .padding(.horizontal)
        
    }
    var emptyImage:some View{
        RoundedRectangle(cornerRadius: 20)
            .stroke(lineWidth: 3)
            .frame(width: 100, height: 100)
            .overlay {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30,height: 30)
            }
            .foregroundColor(.black)
    }
    func modifyModeSchedule(){
        startDate = (vm.page?.dateRange.first?.dateValue() ?? Date())
        endDate = (vm.page?.dateRange.last?.dateValue() ?? Date())
        
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
}


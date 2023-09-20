//
//  SelectTypeView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/21.
//

import SwiftUI
import PhotosUI
import Kingfisher
import FirebaseFirestore

struct AddPageView: View {
    
    @State var title = ""
    @State var text = ""
    @State var overseas:Bool? = nil
    @State var startDate = Date()
    @State var endDate = Date() + 86400
    
    @State var isPage = false   //페이지 생성/수정 시 progressView 띄우기 위함
    @State var changedDate = false  //날짜 수정 시 해당 일자의 일정 모두 삭제의 허용을 묻는 문구
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            VStack(spacing:10){
                header
                ScrollView{
                    settingPageInfo
                    settingDate
                    settingOversease
                    Spacer()
                }
                
            }
            if isPage{
                CustomProgressView(title: vm.page != nil ? "페이지 수정중.." : "페이지 생성중..")
            }
            
        }
        .foregroundColor(.black)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onReceive(vm.succenss) {
            dismiss()
        }
        .alert(isPresented: $changedDate) {
            Alert(
                title: Text("경고"),
                message: Text("페이지의 날짜가 바뀌게 되면 해당 날짜의 일정은 모두 삭제 됩니다. 날짜를 수정하시겠습니까?"),
                primaryButton: .destructive(Text("확인")) {
                    isPage = true
                    scheduleDelete()
                }, secondaryButton: .cancel(Text("취소")))
        }
        .onDisappear{
            vm.schedule = nil
            vm.data = nil
            vm.selection = nil
        }
    }
}

struct AddPageView_Previews: PreviewProvider {
    static var previews: some View {
        AddPageView()
            .environmentObject(AuthViewModel())
            .environmentObject(PageViewModel())
    }
}

extension AddPageView{
    var header:some View{
        HStack{
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(.black)
            }
            .padding()
            Spacer()
            if overseas != nil && !text.isEmpty && !title.isEmpty{
                Button {
                    if let user = vmAuth.user,let overseas{
                        if  vm.page != nil{
                            changedDate = true
                        }else{
                            isPage = true
                            vm.creagtePage(user:user, pageInfo: Page(pageId: "", pageAdmin: "",pageImageUrl: "",pageImagePath: "", pageName: title, pageOverseas: overseas, pageSubscript: text, dateRange: vm.generateTimestamp(from: startDate, to: endDate)))
                        }
                    }
                } label: {
                    Text(vm.page != nil ? "변경" : "완료")
                        .padding()
                        .foregroundColor(.black)
                }
            }else{
                Text("완료")
                    .padding()
                    .foregroundColor(.gray)
            }
            
        }
        
    }
    var settingPageInfo:some View{
        VStack{
            Text("어디로 여행하세요?")
                .font(.title)
                .bold()
                .padding(.bottom,10)
            Text("방제목, 소개글, 사진 등을 선택해 주세요")
                .foregroundColor(.gray)
                .padding(.bottom)
            PhotosPicker(
                selection: $vm.selection,
                matching: .images,
                photoLibrary: .shared()) {
                    if let selectedImageData = vm.data,
                       let uiImage = UIImage(data: selectedImageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 50))
                        
                    }else{
                        if let image = vm.page?.pageImageUrl{
                            KFImage(URL(string: image))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                        }else{
                            emptyImage
                        }
                        
                    }
                }
                .overlay(alignment:.topTrailing,content: {
                    if vm.data != nil || vm.page?.pageImageUrl != nil{
                        Button {
                            vm.data = nil
                            vm.page?.pageImageUrl = nil
                            vm.page?.pageImagePath = nil
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
                    }
                    
                })
                .onChange(of: vm.selection) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            vm.data = data
                        }
                    }
                }
                .padding(.bottom)
            CustomTextField(placeholder: "제목..", isSecure: false,color: .black, text: $title)
                .padding(.horizontal,100)
            CustomTextField(placeholder: "소개글을 작성해주세요..", isSecure: false,color: .black, text: $text)
                .padding()
        }
    }
    
    var settingDate:some View{
        VStack{
            HStack{
                DatePicker("가는 날", selection: $startDate,in:(Date())...,displayedComponents: .date)
                    .environment(\.locale, .init(identifier: "ko_KR"))
                Text("부터")
            }
            HStack{
                DatePicker("오는 날", selection: $endDate,in:(startDate...),displayedComponents: .date)
                    .environment(\.locale, .init(identifier: "ko_KR"))
                Text("까지")
            }
        }
        .environment(\.colorScheme, .light)
        .environment(\.locale, Locale.init(identifier: "ko"))
        .bold()
        .padding(.horizontal,30)
    }
    var settingOversease:some View{
        HStack{
            Group{
                VStack{
                    Button {
                        overseas = false
                    } label: {
                        Image("korean")
                            .resizable()
                            .frame(width: 120,height: 120)
                            .overlay {
                                Circle()
                                    .frame(width: 120,height: 120)
                                    .foregroundColor(overseas ?? true ? .clear : .black.opacity(0.3))
                            }
                        
                    }
                    Text("국내")
                    
                }
                VStack{
                    Button {
                        overseas = true
                    } label: {
                        Image("over")
                            .resizable()
                            .frame(width: 120,height: 120)
                            .overlay {
                                Circle()
                                    .frame(width: 120,height: 120)
                                    .foregroundColor(overseas ?? false ? .black.opacity(0.3) : .clear)
                                
                            }
                    }
                    Text("해외")
                }
            }
            .padding()
            .bold()
            .frame(height: 200)
            .shadow(radius: 5)
        }
        .padding()
    }
    var emptyImage:some View{
        RoundedRectangle(cornerRadius: 50)
            .stroke(lineWidth: 3)
            .frame(width: 120, height: 120)
            .overlay {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 30,height: 30)
            }
            .foregroundColor(.black)
    }
    func isTimeContationDate(startDate: Timestamp, currentDate: Timestamp) -> Timestamp? {
        
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: startDate.dateValue())
        let endDay = calendar.date(byAdding: .second,value: 86399, to: startDay)
        
        if !(currentDate.dateValue() >= startDate.dateValue() && currentDate.dateValue() <= endDay!) {
            return currentDate
        }else{
            return nil
        }
    }
    func scheduleDelete(){
        Task{
            if let page = vm.page,let user = vmAuth.user,let overseas{
                let currentDate = page.dateRange
                let modifiyngDate = vm.generateTimestamp(from: startDate, to: endDate)
                let modifiedPage = Page(pageId: page.pageId, pageAdmin: page.pageAdmin, pageImagePath: page.pageImagePath, pageName: title, pageOverseas: overseas, pageSubscript: text, dateRange: modifiyngDate)
                
                
                let changed = currentDate.filter{!(modifiyngDate.contains($0))}
                for change in changed {
                    if let schedule = vm.schedules.first(where: {$0.startTime == change}){
                        vm.deleteSchedule(user: user, pageId: page.pageId, schedule: schedule)
                    }
                }
                vm.updatePage(user: user, pageInfo: modifiedPage)
            }
        }
    }
}

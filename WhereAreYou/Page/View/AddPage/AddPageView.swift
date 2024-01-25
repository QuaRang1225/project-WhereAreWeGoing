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
    
    @State var data:Data? = nil
    @State var selection:PhotosPickerItem? = nil
    
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State var pageImage = CustomDataSet.shared.backgroudImage.first!
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            VStack{
                header
                ScrollView{
                    VStack(alignment: .leading){
                        Group{
                            settingPageImage
                            settingPageInfo
                        }
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                        }
                        settingDate
                        Button {
                            guard overseas != nil && !text.isEmpty && !title.isEmpty else { return }
                            guard let user = vmAuth.user,let overseas else {return}
                            
                            if  vm.page != nil{
                                changedDate = true
                            }else{
                                isPage = true
                                let page = Page(pageId: "", pageAdmin: "",pageImageUrl: "",pageImagePath: "", pageName: title, pageOverseas: overseas, pageSubscript: text, dateRange: vm.generateTimestamp(from: startDate, to: endDate))
                                vm.creagtePage(user:user, pageInfo: page,item: selection, image: pageImage)
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(height: 50)
                                .foregroundColor(overseas != nil && !text.isEmpty && !title.isEmpty ? .customCyan3 : .gray)
                                .overlay {
                                    Text(vm.page != nil ? "변경" : "완료")
                                        .foregroundColor(.white)
                                }
                                .bold()
                                .padding()
                                
                        }
                    }
                }
                
            }
            if isPage{
                CustomProgressView(title: vm.page != nil ? "페이지 수정중.." : "페이지 생성중..")
            }
            
        }
        .onReceive(vm.addDismiss){ pageId in
            vmAuth.user?.pages?.append(pageId)
            dismiss()
        }
        .foregroundColor(.black)
       
        .alert(isPresented: $changedDate) {
            Alert(
                title: Text("경고"),
                message: Text("페이지의 날짜가 바뀌게 되면 해당 날짜의 일정은 모두 삭제 됩니다. 날짜를 수정하시겠습니까?"),
                primaryButton: .destructive(Text("확인")) {
                    isPage = true
                    scheduleDelete()
                }, secondaryButton: .cancel(Text("취소")))
        }
    }
}

struct AddPageView_Previews: PreviewProvider {
    static var previews: some View {
        AddPageView()
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
            .environmentObject(PageViewModel(page: nil, pages: CustomDataSet.shared.pages()))
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
            .padding(.bottom)
            Spacer()
            

            
        }
        .padding(.leading)
    }
    var settingPageImage:some View{
        VStack(alignment: .leading){
            Text("어디로 여행하세요?")
                .bold()
                .font(.title)
            Text("방제목, 소개글, 사진 등을 선택해 주세요")
                .foregroundColor(.gray)
                .padding(.bottom)
            Group{
                if let selectedImageData = data,
                   let uiImage = UIImage(data: selectedImageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                }else{
                    KFImage(URL(string: pageImage))
                        .resizable()
                        .placeholder{
                            Color.gray.opacity(0.2)
                        }
                }
            }
            .frame(height: 200)
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
                    ForEach(CustomDataSet.shared.backgroudImage,id: \.self){ image in
                        Button{
                            data = nil
                            selection = nil
                            pageImage = image
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
                    self.pageImage.removeAll()
                }
            }
        }
        .padding([.horizontal,.bottom])
    }
    var settingPageInfo:some View{
        VStack(alignment: .leading){
            HStack(alignment: .bottom){
                Text("페이지 정보")
                    .bold()
                    .font(.title2)
                Spacer()
                settingOversease
            }
           
            CustomTextField(placeholder: "제목..", isSecure: false,text: $title)
                .padding(.trailing,100)
            CustomTextField(placeholder: "소개글을 작성해주세요..", isSecure: false, text: $text)
        }
        .padding()
    }
    
    var settingDate:some View{
        VStack(alignment:.leading){
            HStack{
                DatePicker("가는날", selection: $startDate,in:(Date())...,displayedComponents: .date)
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
        .padding(.horizontal)
    }
    var settingOversease:some View{
        HStack(spacing: 15){
            Group{
                VStack{
                    Button {
                        overseas = false
                    } label: {
                        Image("korean")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .overlay {
                                Circle()
                                    .frame(width: 30,height: 30)
                                    .foregroundColor(overseas ?? true ? .clear : .black.opacity(0.3))
                            }
                        
                    }
                    Text("국내")
                        .font(.caption)
                }
                VStack{
                    Button {
                        overseas = true
                    } label: {
                        Image("over")
                            .resizable()
                            .frame(width: 30,height: 30)
                            .overlay {
                                Circle()
                                    .frame(width: 30,height: 30)
                                    .foregroundColor(overseas ?? false ? .black.opacity(0.3) : .clear)
                                
                            }
                    }
                    Text("해외")
                        .font(.caption)
                }
            }
            .shadow(radius: 5)
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
    }
    
    //------------ 페이지의 일정 변경 시 삭제되는 일자의 스케쥴이 있을 경우 그 스케쥴 삭제
    func scheduleDelete(){
        Task{
            guard let page = vm.page,let user = vmAuth.user,let overseas else {return}
            
            let currentDate = page.dateRange    //현재 페이지의 날짜들
            let modifiyngDate = vm.generateTimestamp(from: startDate, to: endDate)  //뷰에서 설정한 날짜들
            
            let modifiedPage = Page(pageId: page.pageId, pageAdmin: page.pageAdmin, pageImagePath: page.pageImagePath, pageName: title, pageOverseas: overseas, pageSubscript: text, dateRange: modifiyngDate)  //수정되어 저장할 페이지
            
            
            let changed = currentDate.filter{!(modifiyngDate.contains($0))}
            for change in changed {
                guard let schedule = vm.schedules.first(where: {$0.startTime == change}) else{ return }
                vm.deleteSchedule(pageId: page.pageId, schedule: schedule)
            }
            vm.updatePage(user: user, pageInfo: modifiedPage,item: selection)
        }
        
    }
}

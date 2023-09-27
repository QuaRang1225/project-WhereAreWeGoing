//
//  PageSettingView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/09/20.
//

import SwiftUI

struct PageSettingView: View {
    
    @State var delete = false   //삭제 버튼 활성화
    @State var out = false
    var page:Page
    @Binding var deletePage:Bool   //삭제버튼 클릭 후 삭제 중 문구
    
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                if page.pageAdmin == vmAuth.user?.userId{
                    NavigationLink {
                        AddPageView(title: page.pageName ,text: page.pageSubscript,overseas: page.pageOverseas, startDate: page.dateRange.first?.dateValue() ?? Date(),endDate: page.dateRange.last?.dateValue() ?? Date())
                            .environmentObject(vm)
                            .environmentObject(vmAuth)
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("수정하기")
                           
                    }.padding(.top,7.5)
                    Divider()
                    Button {
                        delete = true
                    } label: {
                        Text("삭제하기").foregroundColor(.red)
                    }
                    Divider()
                }else{
                    Button {
                        out = true
                    } label: {
                        Text("나가기").foregroundColor(.red)
                    }
                    Divider()
                }
            }
            
        }
        
        .padding(.leading)
        .confirmationDialog("일정 수정", isPresented: $delete, actions: {
            Button(role:.destructive){
                guard let page = vm.page,let user = vmAuth.user else {return}
                deletePage = true
                vm.deletePage(user:user,page: page)
            } label: {
                Text("삭제하기")
            }
        },message: {
            Text("정말 이 페이지를 삭제하시겠습니까?")
        })
        .confirmationDialog("", isPresented: $out, actions: {
            Button(role:.destructive){
                if let user = vmAuth.user,let page = vm.page{
                    deletePage = true
                    vm.outPage(user: user, page:page)
                }
            } label: {
                Text("나가기")
            }
        },message: {
            Text("정말 이 페이지를 나가시겠습니까?")
        })
    }
}

struct PageSettingView_Previews: PreviewProvider {
    static var previews: some View {
        PageSettingView(page: CustomDataSet.shared.page(), deletePage: .constant(true))
            .environmentObject(AuthViewModel())
            .environmentObject(PageViewModel())
    }
}

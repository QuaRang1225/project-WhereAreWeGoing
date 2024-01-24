//
//  SelectAddressView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/28.
//

import SwiftUI

struct SelectAddressView: View {
    
    @EnvironmentObject var vm:PageViewModel
    @EnvironmentObject var vmAuth:AuthViewModel
    @EnvironmentObject var location:LocationMagager
    
    @State var isShcedule = false
    @Binding var isPage:Bool
    
    var body: some View {
        VStack{
            header
            ZStack(alignment: .bottom){
                MapViewHelper()
                    .overlay {
                        Image("where")
                            .resizable()
                            .frame(width: 50,height: 70)
                            .offset(y:location.isChanged ? -45 : -35)
                            .background{
                                Capsule()
                                    .frame(width: 20,height: 15)
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                    }
                    .environmentObject(location)
                    
                if !location.isChanged{
                    VStack{
                        if vm.copy{
                            Text("클립보드에 복사되었습니다.")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                                .padding(5)
                                .background{
                                    Capsule()
                                        .foregroundColor(.black)
                                        .opacity(0.5)
                                }
                                .padding(.bottom)
                                
                        }
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .frame(height: UIScreen.main.bounds.height/3.5)
                            .overlay {
                                VStack(alignment: .trailing){
                                    Button {
                                        vm.copyToPasteboard(text: "\(location.pickedPlaceMark?.thoroughfare ?? "") \(location.pickedPlaceMark?.subThoroughfare ?? "")")
                                    } label: {
                                        HStack{
                                            Text("주소 복사")
                                            Image(systemName: "square.on.square")
                                        }
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                    }.padding(.trailing)

                                    VStack(alignment: .leading){
                                        
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.customCyan2)
                                            .padding(.bottom,5)
                                        HStack{
                                            Text(location.pickedPlaceMark?.country ?? "")
                                                .font(.title3)
                                            Text(location.pickedPlaceMark?.administrativeArea ?? "")
                                        }
                                        .bold()
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
                                    }
                                    .padding(.horizontal)
                                    SelectButton(color: .customCyan2, textColor: .white, text: "확인") {
                                        isShcedule = true
                                    }
                                }
                                .foregroundColor(.black)
                                
                            }
                            .ignoresSafeArea()
                            .transition(.move(edge: .bottom))
                            .animation(.easeIn, value: location.isChanged)
                    }
                    
                }
            }.edgesIgnoringSafeArea(.bottom)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationDestination(isPresented: $isShcedule) {
            AddScheduleView(isPage: $isPage)
                .environmentObject(vm)
                .environmentObject(vmAuth)
                .environmentObject(location)
                .navigationBarBackButtonHidden()
        }
    }
}

struct SelectAddressView_Previews: PreviewProvider {
    static var previews: some View {
        SelectAddressView(isPage: .constant(true))
            .environmentObject(LocationMagager())
            .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
            .environmentObject(PageViewModel())
    }
}

extension SelectAddressView{
    var header:some View{
        ZStack(alignment: .top){
            Text("상세 주소")
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
                    
                }
                
            }
            
        }
        .foregroundColor(.black)
        
    }
    
}

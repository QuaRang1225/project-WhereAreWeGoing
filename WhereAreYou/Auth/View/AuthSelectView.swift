//
//  AuthSelectView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 1/23/24.
//

import SwiftUI

struct AuthSelectView: View {
    
    @State var login = false
    @State var register = false
    @State private var rotation: Double = 0.0
    @EnvironmentObject var vm:AuthViewModel
    
    var body: some View {
        
        VStack{
            header
            ZStack{
                
                Image("space")
                    .resizable()
                    .frame(width: 300,height:250)
                Image("earth")
                    .resizable()
                    .rotationEffect(.degrees(rotation))
                    .overlay{
                        Image("shade")
                            .resizable()
                            .offset(x:18,y:14)
                            .frame(width: 175,height: 175)
                    }
                    .frame(width: 200,height: 200)
                    .padding(.top,120)
                    .onAppear() {
                        withAnimation(.linear(duration: 80).repeatForever()){
                            self.rotation = 360.0 // 초기 회전 각도 설정
                        }
                    }
                Image("plain")
                    .resizable()
                    .frame(width: 70,height: 70)
                    .offset(y:-40)
                
                
            }
            Spacer()
            Button {
                login = true
            } label: {
                Text("로그인 하기")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.customCyan3)
                    .cornerRadius(10)
                    .bold()
                    .padding(.horizontal)
            }
            .padding(.bottom,5)
            Button {
                register = true
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    
                    .stroke(.gray,lineWidth:1)
                    .foregroundStyle(.white)
                    .frame(height: 50)
                    .padding(0.5)
                    .background()
                    .overlay{
                        Text("회원가입 하기")
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal)
            }
            Spacer()
        }
        .background{
            Color.white.ignoresSafeArea()
        }
        .sheet(isPresented: $login) {
            LoginView()
                .environment(\.colorScheme,.light)
                .environmentObject(vm)
        }
        .sheet(isPresented: $register) {
            RegisterView()
                .environment(\.colorScheme,.light)
                .environmentObject(vm)
        }
        
    }
}

#Preview {
    AuthSelectView()
        .environmentObject(AuthViewModel(user: CustomDataSet.shared.user()))
        .environment(\.colorScheme, .light)
}

extension AuthSelectView{
    var header:some View{
        HStack{
            VStack(alignment: .leading){
                Text("환영합니다.")
                    .font(.largeTitle)
                    .padding(.bottom,5)
                Text("우리 어디갈까요?")
            }
            .bold()
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical)
        .padding(.bottom)
    }
}

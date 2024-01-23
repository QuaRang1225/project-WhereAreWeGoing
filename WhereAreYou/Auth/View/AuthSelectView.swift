//
//  AuthSelectView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 1/23/24.
//

import SwiftUI

struct AuthSelectView: View {
    
    @State private var rotation: Double = 0.0
    @EnvironmentObject var vm:AuthViewModel
    
    var body: some View {
        VStack{
            header
            NavigationLink {
                LoginView()
                    .environmentObject(vm)
            } label: {
                Text("로그인 하기")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.customCyan2)
                    .cornerRadius(10)
                    .bold()
                    .padding(.horizontal)
            }
            .padding(.bottom,5)
            NavigationLink {
                RegisterView()
                    .environmentObject(vm)
            } label: {
                Text("회원가입 하기")
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.white)
                    .cornerRadius(10)
                    .bold()
                    .padding(.horizontal)
            }
            Spacer()
        }
        .background{
            ZStack{
                Image("over")
                    .resizable()
                    .frame(width: 1000, height: 1000)
                    .foregroundColor(.blue)
                    .rotationEffect(.degrees(rotation))
                    .offset(y:500)
                    .onAppear() {
                        withAnimation(.linear(duration: 60).repeatForever()){
                            self.rotation = 360.0 // 초기 회전 각도 설정
                        }
                    }
                    .opacity(0.3)
                Color.gray.opacity(0.1).ignoresSafeArea()
            }
        }
    }
}

#Preview {
    AuthSelectView()
        .environmentObject(AuthViewModel())
}

extension AuthSelectView{
    var header:some View{
        HStack{
            VStack(alignment: .leading){
                Text("환영합니다.")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom,5)
                Text("여행.. 준비됐어요..?")
            }
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical)
        .padding(.bottom)
    }
}

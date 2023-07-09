//
//  TestView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/09.
//

import SwiftUI

class AA:ObservableObject{
    @Published var aa = false
}
struct TestView: View {
    @StateObject var vm = AA()
    var body: some View{
        if vm.aa{
            Text("asda")
        }else{
            AAA()
                .environmentObject(vm)
        }
    }
}
struct AAA:View{
    
    @State var a = false
    @EnvironmentObject var vm:AA
    var body: some View {
        Button {
            a =  true
        } label: {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .sheet(isPresented: $a) {
            BBB()
                .environmentObject(vm)
        }
    }
}
struct BBB:View{
    
    @EnvironmentObject var vm:AA
    var body: some View {
        Button {
            vm.aa =  true
        } label: {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

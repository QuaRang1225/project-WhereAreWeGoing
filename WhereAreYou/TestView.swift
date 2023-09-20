//
//  TestView.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/09.
//


//class AA:ObservableObject{
//    @Published var aa = false
//}
//struct TestView: View {
//    @StateObject var vm = AA()
//    var body: some View{
//        if vm.aa{
//            Text("asda")
//        }else{
//            AAA()
//                .environmentObject(vm)
//        }
//    }
//}
//struct AAA:View{
//
//    @State var a = false
//    @EnvironmentObject var vm:AA
//    var body: some View {
//        Button {
//            a =  true
//        } label: {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//        }
//        .sheet(isPresented: $a) {
//            BBB()
//                .environmentObject(vm)
//        }
//    }
//}
//struct BBB:View{
//
//    @EnvironmentObject var vm:AA
//    var body: some View {
//        Button {
//            vm.aa =  true
//        } label: {
//            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//        }
//    }
//}
import Foundation
import SwiftUI
import UIKit
import MapKit
import CoreLocation
import Combine

import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import FirebaseFirestore


struct Doc:Codable,Identifiable{
    var id:String
    var name:String
    var age:Int?
}

class TestClass{
    static let instance = TestClass()
    var collection:CollectionReference{
        Firestore.firestore().collection("test")
    }
    func writeDocument(name:String) async throws{   //쓰기
        let field = collection.document()
        let data:[String:Any] = [
            "id":field.documentID,
            "name":name
        ]
        print("이름 추가")
        try await field.setData(data)
    }
    
    func updateDocument(id:String) async throws{   //수정
        let field = collection.document(id)
        let data:[String:Any] = [
            "age":25
        ]
        print("나이 추가")
        try await field.updateData(data)
    }
    
    func readDocument() async throws -> [Doc]{  //읽기
        var docs:[Doc] = []
//        let listener = collection.addSnapshotListener({ snapshot, error in
//            guard let documents = snapshot?.documentChanges else {return}
//            for change in documents{
////                docs = try await collection.getAllDocuments(as: Doc.self)
//                docs.append(try await change.document.reference.getDocument(as:Doc))
//            }
//        })
        
        return docs
    }
}

struct TestView:View{
    
    @State var docs:[Doc] = []
    var body: some View {
       
        VStack{
            Group{
                Text("이름 추가")
                    .onTapGesture {
                        Task{
                            try await TestClass.instance.writeDocument(name: "유영웅")
                            self.docs = try await TestClass.instance.readDocument()
                        }
                    }
                   
            }
            .padding()
            .bold()
            .background(Color.customCyan2)
            .cornerRadius(20)
            ForEach(docs) { doc in
                /*@START_MENU_TOKEN@*/Text(doc.id)/*@END_MENU_TOKEN@*/
                    .onTapGesture {
                        Task{
                            try await TestClass.instance.updateDocument(id:doc.id)
                            self.docs = try await TestClass.instance.readDocument()
                        }
                    }
                if let age = doc.age{
                    Text("\(age)")
                }
            }
        }.foregroundColor(.primary)
            .onAppear{
                Task{
                    self.docs = try await TestClass.instance.readDocument()
                }
            }
    }
}



struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct MapView:UIViewRepresentable{
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(parent: self)
    }
    
    @Binding var contry:String
    @Binding var city:String
    @Binding var title:String
    @Binding var subtitle:String
    @Binding var isChanged:Bool
    
    @Binding var region:MKCoordinateRegion
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) ->MKMapView {
        
        let map = MKMapView()
        
        map.setRegion(region, animated: true)
        map.delegate = context.coordinator
        return map
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
    }
    
    class Coordinator:NSObject,MKMapViewDelegate{
        
        
        
        var parent:MapView
        init(parent: MapView) {
            self.parent = parent
            
        }
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            DispatchQueue.main.async {
                self.parent.isChanged = true
            }
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated: Bool) {
            let location: CLLocation = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
            
            self.convertLocationToAddress(location: location)
            DispatchQueue.main.async {
                self.parent.isChanged = false
            }
        }
        
        
        func convertLocationToAddress(location: CLLocation) {
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "ko")
            
            geocoder.reverseGeocodeLocation(location,preferredLocale: locale) { placemarks, error in
                guard error == nil else{ return }
                
                guard let placemark = placemarks?.first else { return }
                self.parent.contry = "\(placemark.country ?? "")"
                self.parent.city = "\(placemark.locality ?? "") \(placemark.name ?? "")"
            }
        }
    }
}

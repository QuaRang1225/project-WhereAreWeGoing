//
//  CustomDataSet.swift
//  WhereAreYou
//
//  Created by 유영웅 on 2023/07/11.
//

import Foundation
import FirebaseFirestore

class CustomDataSet{
    static let shared  = CustomDataSet()
    private init(){}

    let basicImage = "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/%E1%84%8B%E1%85%B3%E1%84%83%E1%85%B5%E1%84%89%E1%85%B5%E1%86%B7.png?alt=media&token=a1460508-cdb3-4ff7-935e-8b3eea55530b"
    
    let images = [
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2016.png?alt=media&token=0938bc0d-1be3-43cd-882b-35822789b435",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2017.png?alt=media&token=73705217-762f-4772-88e0-b7e90a00a775",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2018.png?alt=media&token=3a2b9c5c-a1e6-44ce-81c0-1927f965800f",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2019.png?alt=media&token=aab22f97-c235-4dc2-b530-cf3f2c000a45",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2020.png?alt=media&token=ddca2cdc-2939-4a12-bf72-7c9b7d468d29",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2021.png?alt=media&token=d33bd32b-cc68-49d4-9c5c-3300d45dee39",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2022.png?alt=media&token=ef2264ec-4e35-44d3-b61f-12002fd359a7",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/basic%2FGroup%2023.png?alt=media&token=a1003133-8e84-435e-be01-d3633c5fa0a3"
    
    ]
    let placeImage = [
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2F11e6e70a-e29c-4cc7-8024-34c0376f526a.png?alt=media&token=629b30c1-86e4-478a-b0dd-be32b732f925",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2F13431970-51e2-44dd-bdd2-c0bb292a57e5.png?alt=media&token=a3d0df34-2d4f-47eb-a178-f93bed0a94b7",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2F34dbe03e-6e0f-4ce5-a97c-9d4b8b5905ae.png?alt=media&token=409520fa-0191-4134-a1b5-707aa688a339",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2F7178dcbc-ba69-4b02-b05a-28d0a91c8a94.png?alt=media&token=61748fa4-0d5a-4421-a564-2600021c53a1",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2F773f6825-01ae-4c75-a106-118cc8b460ff.png?alt=media&token=5c9aa158-20c2-4683-a111-06ddd2e07ea0",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2F905e12e3-82ba-4583-8750-6a8dd2ca1e17.png?alt=media&token=b0c57876-6267-48db-baf7-5804dec36e76",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2Fa09fc673-e978-471b-b785-61692a05aea1.png?alt=media&token=2f0bab7c-d390-4823-8f94-3c36ea40c648",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2Fceb1a063-7d9b-4d40-86dd-10d1b2c60fc7.png?alt=media&token=031ad50d-313d-4931-9230-e99201fe8bcd",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2Fd204433e-d017-47df-94e7-cdc147edbca4.png?alt=media&token=e4e1a421-d2e1-475c-88fa-c8611d113abc",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2Fdc3a3448-2cbb-474f-831d-32176f10450d.png?alt=media&token=58834ba4-03f2-4977-9759-4edcd859c66b",
    "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/place%2Ffa62e1cc-07f4-43fc-8860-f4d4b4054e6e.png?alt=media&token=a9b5437e-5e80-49dc-8574-034f55cb0af8"
    ]
    let backgroudImage = [
        "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/city%2F1639a559-1798-482f-ab70-a54b9093168c.png?alt=media&token=d4fbb014-b8a0-4d7c-b5db-34eb7bafd6c9",
        "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/city%2F16ac5928-08ff-4639-908d-af6a8d998c20.png?alt=media&token=a810522e-d2a5-4f22-98a0-d3336c7d3de5",
        "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/city%2F1730dba3-d5dc-4e96-96eb-7806444ec959.png?alt=media&token=f9afc43c-a146-4b29-b938-56025bc04576",
        "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/city%2F40bdf8aa-7723-4a90-b78e-42bbc0744311.png?alt=media&token=1bfc8238-ef13-4f97-bd84-f2db394e5102",
        "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/city%2F5d72208f-e2fc-443a-9f06-1499bf6bb4c5.png?alt=media&token=eb3032c8-7820-40e7-80e4-fbe3d35051ce",
        "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/city%2Faf584690-9125-4966-8d20-5a1f86b2241a.png?alt=media&token=931ab283-e50c-4045-960c-d4fd97b93678",
        "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/city%2Ff34f7802-67f2-49ac-86c5-57a972b4195f.png?alt=media&token=bf24a8d8-0386-426f-9106-7305a178b891",
        "https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/city%2Ff704fa9b-b182-4bb3-83da-d95db6a40523.png?alt=media&token=75b2c893-4581-4fd2-9d3d-8aeb095d7ab0"
        
    ]

    func page() -> Page{
        Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.backgroudImage.first!, pageImagePath: nil, pageName: "으딩이", pageOverseas: false, pageSubscript: "으딩이와 함께 하는 우리어디가", request: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],members: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],dateRange: [Timestamp(date: "2023년 07월 26일".toDate()),Timestamp(date: "2023년 07월 27일".toDate()),Timestamp(date: "2023년 07월 28일".toDate()),Timestamp(date: "2023년 07월 29일".toDate())])
    }
    
    func schedule() -> Schedule{
        Schedule(id:"asdasdas",imageUrl:"https://firebasestorage.googleapis.com/v0/b/whereareyou-66f3a.appspot.com/o/page_image%2F4KYzTqO9HthK3nnOUAyIMKcaxa03%2F125AFB52-3B93-4F16-B101-09AC390A6715.jpeg?alt=media&token=f98a6c58-c46f-474c-bf81-ff3fe7c09e00", category: "카페/휴식", title: "아무", startTime: "1:00PM".toDate().toTimestamp(), endTime: "3:00PM".toDate().toTimestamp()  , content: "아무게\n아무게", location: GeoPoint(latitude: 36.298959, longitude: 127.354729), link:["asd":"https://console.firebase.google.com/u/0/project/whereareyou-66f3a/firestore/data/~2Fusers~2F4KYzTqO9HthK3nnOUAyIMKcaxa03~2Fpage~2F6DORTzvH6zavb7g49BrB~2Fschedule?hl=ko"])
    }
    func pages() -> [Page]{
        [
            Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.images.first!, pageImagePath: nil, pageName: "으딩이", pageOverseas: false, pageSubscript: "으딩이와 함께 ", request: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],members: ["4KYzTqO9HthK3nnOUAyIMKmembers"],dateRange: [Timestamp(date: "2023년 07월 26일".toDate()),Timestamp(date: "2023년 07월 27일".toDate()),Timestamp(date: "2023년 07월 28일".toDate()),Timestamp(date: "2023년 07월 29일".toDate())]),
            Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.images[1], pageImagePath: nil, pageName: "으딩이", pageOverseas: true, pageSubscript: "으딩이와 함께 하는 우리", request: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],members: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],dateRange: [Timestamp(date: "2023년 07월 26일".toDate()),Timestamp(date: "2023년 07월 27일".toDate()),Timestamp(date: "2023년 07월 28일".toDate()),Timestamp(date: "2023년 07월 29일".toDate())]),
            Page(pageId: "asdasdadsad", pageAdmin: "4KYzTqO9HthK3nnOUAyIMKcaxa03", pageImageUrl: CustomDataSet.shared.images[2], pageImagePath: nil, pageName: "으딩이", pageOverseas: true, pageSubscript: "으딩이와 함께 하는디가", request: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],members: ["4KYzTqO9HthK3nnOUAyIMKcaxa03"],dateRange: [Timestamp(date: "2023년 07월 26일".toDate()),Timestamp(date: "2023년 07월 27일".toDate()),Timestamp(date: "2023년 07월 28일".toDate()),Timestamp(date: "2023년 07월 29일".toDate())])
         
         
         
         ]
    }
    func user() ->UserData{
        UserData(userId: "4KYzTqO9HthK3nnOUAyIMKcaxa03", nickname: "콰랑", email: "dbduddnd1225@gmail.com", dateCreated: "2023년 07월 29일", profileImageUrl:"https://firebasestorage.googleapis.com:443/v0/b/whereareyou-66f3a.appspot.com/o/users%2FKZ9JPJYGB2NnoDfjz3Ayq9X1d8D3%2F94F078A6-F6A0-4606-AB47-2FA3DD021BF0.jpeg?alt=media&token=96bdd7de-70ca-46fd-9fee-14db1db4177c", profileImagePath: "users/KZ9JPJYGB2NnoDfjz3Ayq9X1d8D3/94F078A6-F6A0-4606-AB47-2FA3DD021BF0.jpeg", pages: CustomDataSet.shared.pages().map({$0.pageId}), guestMode: true)
    }

}

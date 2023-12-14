# 우리어디가

![스크린샷 2023-12-04 오후 5.53.56.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/50c2cb20-df2d-45ac-87bf-ce6a78cfc5d7/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-12-04_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_5.53.56.png)

---

### 🔗 관련링크

[‎우리어디가](https://apps.apple.com/kr/app/%EC%9A%B0%EB%A6%AC%EC%96%B4%EB%94%94%EA%B0%80/id6469308316)

https://github.com/QuaRang1225/WhereAreYou

<aside>
💡 저는 여행을 가기 전에 꼭 여행지에서 무엇을 할 지와 어떤 음식을 먹을지 계획합니다. 가끔 다른 여행자들과 함께 회의하며 계획을 짜거나 이미 짜여진 일정을 공유해야 할 필요가 있을 때 불편한 점이 상당히 많다고 느꼈고, 추가로 일정을 간결하고 보기 쉽게 작성할 수 있으며, 일정 장소를 지도에 표시하여 저장할 수 있는 어플리케이션이 있다면 편할 것 같아 이 프로젝트를 시작하게 되었습니다.

</aside>

### 📱 주요 기능 & 레이아웃

---

> **앱 설명**
> 

**우리어디가**는 여행 일정 공유를 위해 개발되었습니다. 여행자들과 함께 일정을 공유할 수 있도록 그들만의 페이지를 제공하고, 페이지 안에서 세부적으로 계획의 일정을 자유롭게 작성 및 수정하고 일정들은 리스트로 나열됩니다. 일정들은 리스트로 보기와 지도로 보기가 가능합니다. 일정들을 달력에 표시되어 어느 날짜에 여행이 있는지 확인할 수 있습니다.

이미 만들어진 페이지에 가입하고 싶다면 페이지명 혹은 페이지 ID를 검색해 방장에게 요청을 걸고, 방장이 그것을 받아준다면 페이지 맴버가 될 수 있습니다. 맴버와 방장 모두 일정을 생성,수정,삭제할 수 있으며 맴버 강제퇴장이나 페이지 설정은 방장만 가능합니다.

> **레이아웃**
> 

![페이지 작성화면](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/32499a1e-f689-4043-a7a5-0b917777d3ae/rounded-in-photoretrica_(1).png)

페이지 작성화면

![메인화면](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/9699e06e-fa50-413f-83a6-07ef312af170/rounded-in-photoretrica_(4).png)

메인화면

**여행 페이지 작성 및 메인화면**

- 전체 여행 스케쥴 정보를 담은 내용 작성 후 페이지 생성
- 생성한 페이지는 내 일정 리스트에 추가됨

![게시물 작성화면](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/3b1a5de1-51c8-4097-97c3-94e49509ad9f/rounded-in-photoretrica_(2).png)

게시물 작성화면

![일정 리스트 및 지도화면](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/ad3b585d-ee9a-4e8e-a3a1-2c9b96406f7d/Group_36.png)

일정 리스트 및 지도화면

**게시물 작성 화면**

- 일정 기간과 주소 검색, 일정 설명을 작성 후 게시

**일정 리스트 화면**

- 작성된 일정은 페이지 멤버들은 모두 확인,수정,삭제가 가능하며 MapAnnotation으로도 확인가능

![페이지 검색화면](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/758a2ec6-27c7-4b93-a1f6-88ebe6ac0a5d/IMG_9504.png)

페이지 검색화면

![멤버 목록화면](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/c2fdb437-6ce4-4c9e-8b6a-00d704e1de05/IMG_7D2F2AB0AE88-1.jpeg)

멤버 목록화면

**페이지 검색화면** 

- 페이지 혹은 페이지 ID로 검색가능

**멤버 목록화면**

- 멤버가 요청을 걸면 페이지 초대요청에 사용자가 추가됨
- 방장이 수락하면 멤버 일정목록에 페이지가 추가됨
- 방장은 페이지 멤버 강퇴 가능

### 🤔 고민한 점

---

> 타인과 함께 사용하는 앱일 경우 인증 부분은 어떻게 개발할 수 있을까?
> 

먼저 백엔드 인프라를 구축해줄 Baas를 조사하였고, 그 중에서 가장 접근성이 높은 Firebase를 사용했습니다.

- **Authentication**(인증),**FireStore**(데이터베이스),**Storage**(프로필 및 여행지 첨부 이미지 저장)기능 사용
- Firebase iOS SDK를 사용하여 서비스와 상호작용

> 여행지 검색은 어떤 방식으로 해야할까?
> 

![스크린샷 2023-12-04 오후 9.10.11.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/712ed74d-22fb-4731-b950-af4107f1a75c/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-12-04_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.10.11.png)

![스크린샷 2023-12-04 오후 9.23.39.png](https://prod-files-secure.s3.us-west-2.amazonaws.com/c69fd57e-19b5-42cc-9103-f834beb12682/5165b0ff-9a31-4e6c-bba6-239f32fdb235/%E1%84%89%E1%85%B3%E1%84%8F%E1%85%B3%E1%84%85%E1%85%B5%E1%86%AB%E1%84%89%E1%85%A3%E1%86%BA_2023-12-04_%E1%84%8B%E1%85%A9%E1%84%92%E1%85%AE_9.23.39.png)

검색 기능은 다음과 같은 방법을 사용했습니다.

1. TextField에 주소를 입력
2. 0.5초마다 TextField에 있는 문자열로 메서드 호출(검색)
3. 검색결과들을 **CLPlacemark 타입으**로 변형 후 배열에 저장
4. 저장된 주소목록을 뷰로 뿌려줌

```swift
//들어온 값이 포함되어있는 주소들을 찾아서 비동기로 베열에 저장하는 알고리즘
func fetchPlaces(value:String){ 
    Task{
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = value.lowercased()
        let response = try? await MKLocalSearch(request: request).start()
        await MainActor.run(body: {
            self.fetchPlace = response?.mapItems.compactMap({ item -> CLPlacemark? in
                return item.placemark
            })
        })
    }
}
```

### 🔧 앱스토어 리젝 해결

['프로젝트/우리어디가' 카테고리의 글 목록](https://quarang.tistory.com/category/%ED%94%84%EB%A1%9C%EC%A0%9D%ED%8A%B8/%EC%9A%B0%EB%A6%AC%EC%96%B4%EB%94%94%EA%B0%80)

### 프로젝트를 진행 하며..

<aside>
👶🏻 이번 프로젝트는 Firebase를 사용하여 인증을 간편하게 처리할 수 있는 클래스를 제공받고, DB와 Storage를 활용하여 소규모 SNS 앱을 개발하는 게 목적이었습니다. 생각보다 문서도 많고 여러 활용 사례들이 많았기 때문에 어렵지 않게 진행할 수 있었습니다.

인증 및 요청응답은 비동기 이벤트 처리를 위해 async/await를 사용했습니다. 이번에 처음 시도한 기술은 아니지만, 기존보다  sync/concurrency에 대한 이해도와 GCD와의 차이 등 개념을 더 튼튼하게 다질 수 있는 기회였습니다.

처음 Mapkit 프레임워크를 도입했는데, SwiftUI만으로는 아직 완벽한 개발에 무리가 있어 UIkit과 혼용해서 진행했습니다. 제대로 UIkit을 사용해 본 적은 없어 처음에 많은 시행착오가 있었지만, UIkit의 명령형 구조, Coordinator 패턴 등을 같이 공부하며 개발하니 기술력 부족으로 기능을 포기하는 일 없이 프로젝트를 진행할 수 있었습니다.

</aside>

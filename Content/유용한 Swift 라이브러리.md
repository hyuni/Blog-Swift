## 유용한 Swift 라이브러리


그동안 프로젝트를 진행하며 사용한 필수 라이브러리 몇가지를 소개하고자 한다.

1. [Alamofire](https://github.com/Alamofire/Alamofire)
	
	> RESTful 통신 라이브러리로 Objective-C 기반 프로젝트에서는 [AFNetworking](https://github.com/AFNetworking/AFNetworking) 을 이용하였는데 Swift 에서는 Alamofire 를 사용하다. Alamofire 는 AFNetworking 을 만든곳에서 Swift 용으로 새롭게 만든것이니 참고하자
	
2. [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)

	> RESTful 통신은 AFNetworking, Alamofire 등이 처리하고, 이들의 요청/응답은 대부분 JSON format 으로 SwiftyJSON 류의 라이브러리는 encode/decode 등을 내부적으로 처리하고 개발자가 편하게 사용할수 있도록 기능을 제공한다.
	
3. [CocoaAsyncSocket](https://github.com/robbiehanson/CocoaAsyncSocket)

	> 현재 대부분의 앱은 RESTful 통신 기반이지만, 필요에 따라서는 socket 통신을 이용해야 한다. iOS/MacOS 에서 socket 통신은 크게 C, C++ 에서의 berkeley socket 을 이용하는 방법과 Apple 이 제공하는 CFSocket 을 이용하는 방법이 있다. CFSocket 은 BSD socket 을 좀더 사용하기 편하게 구현된것으로 볼수 있다. **CocoaAsyncSocket 은 GCD 기반의 Asynchronous socket 라이브러리이다.**
	
4. [SwiftGen](https://github.com/AliSoftware/SwiftGen)

	> XCode 프로젝트의 리소스. 즉 assets, storyboards, Localizable string, color, font 등을 Swift 에서 쉽게 사용하도록  해주는 유틸리티 성 라이브러리다.	이와 유사한 기능을 제공하는 [R.Swift](https://github.com/mac-cain13/R.swift) 도 있다.
	

### reference
1. [iOSSwiftStarter 의 라이브러리 소개](http://roroche.github.io/iOSSwiftStarter/)
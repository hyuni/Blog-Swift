## XCode8 Playground 에서 cocoapod 라이브러리 사용하기

### why?
XCode8 이전 버전에서도 playground 에서 cocoapod 라이브러리를 이용하고자 하는 시도는 꽤 있었고 잘 되었다.
단, XCode8 버전대 그리고 cocoapods 1.x 버전대에서 이용방법이 명확하지 않았다.

정확하게 이용하는 방법을 정리한다.

### how

1. 준비사항
	* cocoapods 설치
	
		> 홈페이지 Guide :
	
		~~~
		sudo gem install cocoapods
		~~~
	
		> homebrew 이용: 
	
		~~~
		brew install cocoapods
		~~~
	
2. 적용 방법
	* cocoapods-playgrounds 를 이용한 방법
	
		> 
		~~~
		gem install cocoapods-playgrouds
		~~~
	
		> 
		~~~
		pod playgrounds Alamofire
		~~~
	
	
	* XCode Project 를 이용한 방법
	
		> XCode 로 새로운 프로젝트를 생성
	
		> 생성된 프로젝트에서 New Playground 로 playground 추가
	
		> terminal 에서 아래와 같이 Podfile 생성
	
		~~~
		pod init
		~~~
	
	* 공통사항
	
		> Podfile 에 library 추가
	
		> 예) Podfile 
	
		~~~
		use_frameworks!

		target 'AlamofirePlayground' do
		pod 'Alamofire'
		pod 'RxSwift'
		end

		post_install do |installer|
			installer.pods_project.targets.each do |target|
				target.build_configurations.each do |config|
				
					# Swift 버전을 3.x 대로 설정
					config.build_settings['SWIFT_VERSION'] = '3.0.1'

					config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
				end
			end
		end
		~~~
	
		> 기존 Xcode 종료후 생성된 프로젝트의 workspace 를 오픈후 Schema Manager 에서 cocoapod library 추가
	
		![Manage schema](https://github.com/hyuni/Blog-Swift/raw/master/Content/image/manage_schema.png)
		
3. Playground 동작 확인
	
	~~~swift
	import XCPlayground
	XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

	import Alamofire

	Alamofire.request("https://github.com/Alamofire/Alamofire")
		.response { response in
			print("Request: \(response.request)")
			print("Response: \(response.response)")
			print("Error: \(response.error)")
        
			if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
				print("Data: \(utf8Text)")
			}
	}
	~~~		


### 참고 사이트
1. [cocoapods.org](https://guides.cocoapods.org/syntax/podfile.html#abstract_target)

2. [how-to-use-cocoapods-with-playground](http://stackoverflow.com/questions/33367609/how-to-use-cocoapods-with-playground)

3. [cocoapods-playgrounds](https://github.com/segiddins/ThisCouldBeUsButYouPlaying) 




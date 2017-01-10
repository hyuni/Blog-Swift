## XCode Playground 에 TDD를 적용하는 방법

### why?
Swift 2.x 버전대의 문법으로 주로 프로젝트를 진행했으나, 최근 릴리즈된  Swift3 문법이나 간단한 코드를 playground 를 통해 진행하고자했다.

그러면서 playground 에서는 TDD. 즉 XCTestCase 를 적용할수 없을까 하는 궁금증이 생기게 되었다.

Github 사이트에 XCTest 를 적용하는 몇가지 방법을 찾게 되었으나 일부는 제대로 동작하지 않았다.

### how
1. XCode 에서 새로운 Playground 를 생성한다.

2. 생성된 Playground 에서 Project Navigator(키보드: Command + 1) 을 열고 Source 폴더에 TestRunner.swift 를 생성
	- 혹은 [Github 의 TestRunner.swift 를 다운로드](https://github.com/sshrpe/TDDSwiftPlayground/raw/master/TDD%20In%20Swift%20Playgrounds%20-%20iOS.playground/Sources/TestRunner.swift) 한 이후 해당 파일을 Source 폴더에 적용

3. Playground 에 테스트 할 코드를 작성하고 XCTestCase 적용


4. 샘플

```swift
import UIKit
import XCTest

/// Stack 구조체
struct Stack {
}


/// Stack 구조체 TestCase
public class StackTestCase: XCTestCase {
	override func setUp() {
	}
	
	override func tearDown() {
	}
	
	// test 코드 작성
	func testSomething() {
	}
}

/// 마지막으로 TestCase 가 실행 되도록
TestRunner().runTests(testClass: StackTestCase.self)
```	


### 참고 사이트
* [Github 의 TDDSwiftPlayground](https://github.com/sshrpe/TDDSwiftPlayground)
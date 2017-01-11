## Generic Object 의 Equatable

### why?

Swift3 Study 계획의 하나로 [Github 의 Algorithm Club](https://github.com/raywenderlich/swift-algorithm-club) 을 토대로 Swift 문법이나 Generic 등 부족한 부분을 습득해 나가다 다음과 같은 문제에 직면하게 되었다.

1. Stack 객체 비교
	* XCTAssert(stack1.array == stack2.array) or XCTAssertEqual(stack1.array, stack2.array)

	* XCTAssert(stack1 == stack2) or XCTAssertEqual(stack1, stack2) 

	* Test 결과
	>	- [x] XCTAssert(stack1.array == stack2.array) => Test passed.
	>
	>	- [x] XCTAssertEqual(stack1.array, stack2.array) => Test passed.
	>
	>	- [ ] XCTAssert(stack1, stack2) => Test failed.
	>		=> error: binary operator '==' cannot be applied to operands of type 'Stack<String>' and 'Stack<String>!'
	>
	>	- [ ] XCTAssertEqual(stack1, stack2) => Test failed.
	>		=> Cannot invoke 'XCTAssertEqual' with an argument list of type '(Stack<String>, Stack<String>)'
	
	* 결과
		- Stack 의 array 의 경우 Equatable protocol 이 구현되어 있음.
		- Stack 의 Equatable protocol 이 구현되지 않았음.
		 

	```swift
	public struct Stack<T> {
		fileprivate var array = [T]()
		
		/// 나머지 부분은 생략
		/// ...
	}	

	class StackTestCase: XCTestCase {
		func testEquatable() {
			var stack1 = Stack(array: ["Carl", "Lisa", "Stephaie", "Jeff"])
		
			var stack2 = stack1
		
			/// Test passed
			XCTAssert(stack1.array == stack2.array)
			
			XCTAssertEqual(stack1.array, stack2.array)
			
			/// error - error: binary operator '==' cannot be applied to operands of type 'Stack<String>' and 'Stack<String>!'
			XCTAssert(stack1, stack2)
			
			/// error - Cannot invoke 'XCTAssertEqual' with an argument list type '(Stack<String>, Stack<String>!)'
			XCTAssertEqual(stack1, stack2)
		}
	}
	```
	
### How

2. Stack 의 Equatable protocol 구현

	단계 1. 의 결과로 struct Stack 에 Equatable protocol 구현이 필요하단 사실을 알게 되었다.
	
	* Equatable protocol 은 아래와 같다.
		
		```swift
		public protocol Equatable {
			public static func ==(lhs: Self, rhs: Self) -> Bool
		}
		```

	* Step 1) 아래와 같이 Equatable 을 구현했을때 다음과 같은 에러를 만나게 된다.
		> error: binary operator '==' cannot be applied to two '[T]' operands
		
		> T 가 equatable 을 지원되지 않는 Type 일수도 있음.

		```swift
		public struct Stack<T>: Equatable {
			fileprivate var array = [T]()
		
			public static func ==(lhs: Self, rhs: Self) -> Bool {
				/// error: binary operator '==' cannot be applied to two '[T]' operands
				return lhs.array == rhs.array
			}
			
			/// 나머지 부분은 생략
			/// ...
		}	

		class StackTestCase: XCTestCase {
			func testEquatable() {
				/// 위쪽에 있으므로 생략
			}
		}
		```


	* Step 2)
		> T 가 Equatable 인 Type 만 가능하다고 명시하여 문제 해결.
	
		```swift
		public struct Stack<T: Equatable>: Equatable {
			fileprivate var array = [T]()
		
			public static func ==(lhs: Self, rhs: Self) -> Bool {
				return lhs.array == rhs.array
			}
			
			/// 나머지 부분은 생략
			/// ...
		}	

		class StackTestCase: XCTestCase {
			func testEquatable() {
				/// 위쪽에 있으므로 생략
			}
		}
		```

### 참고



### Tag

	swift, Generic, Equatable
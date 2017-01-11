## Generic Object 의 Equatable #2

### why?
이전에 Stack 객체 비교를 위해 Equatable protocol 을 구현했다.

여기서 드는 의문점 몇가지는 다음과 같다.

1. Not-Equal 연산의 경우는 어떻게 될까?
2. 일부에서는 Equatable 의 구현 위치가 는 어디가 맞을까?
3. ===, !== 연산자는 지원하는가?


### how

1. Not-Equal 연산자
	> equal 연산자의 반대이므로 != 연산자를 구현하지 않아도 Equatable protocol 만 구현해되 됨
	
	> 자세한 사항은 아래의 테스트 코드 참고


2. Equatable 의 구현 위치는 어디가 맞을까?
	> Struct, Class 내부인 경우는 이미 확인했으므로 생략
	
	> Struct, Class 외부인 경우에도 내부인 경우와 동일(다만, static 키워드가 제거됨)
	
	> 그렇다면 둘다 있는 경우는?? 결론은 둘다 있어도 문제되지 않음.
	
	
3. ===, !== 연산자는 지원하는가?
	> 아래의  ===, !== 연산자 테스트는 다음과 같은 오류를 발생시킴.
	
	> error: binary operator '===' cannot be applied to operands of type 'Stack<String>' and 'Stack<String>!'
	
	> note: expected an argument list of type '(AnyObject?, AnyObject?)'
	
	> 따라서 해당 연산자는 별도의 구현이 필요.
	
	

	```swift
	public struct Stack<T: Equatable>: Equatable {
		fileprivate var array = [T]()

		/// 2-1. 구현 위치가 안쪽인 경우 		
		public static func ==(lhs: Self, rhs: Self) -> Bool {
			return lhs.array == rhs.array
		}
		
		/// 나머지 부분은 생략
		/// ...
	}
	
	/// 2-2. 구현 위치가 밖인 경우
	public	func ==(lhs: Self, rhs: Self) -> Bool {
		return lhs.array == rhs.array
	}

	class StackTestCase: XCTestCase {
		func testEquatable() {
			var stack1 = Stack(array: ["Carl", "Lisa", "Stephaie", "Jeff"])
		
			var stack2 = stack1
		
			/// Test passed
			XCTAssert(stack1.array == stack2.array)
			
			XCTAssertEqual(stack1.array, stack2.array)
			
			/// Test passed
			XCTAssert(stack1, stack2)
			
			/// Test passed
			XCTAssertEqual(stack1, stack2)
			
			/// Test passed - 1. Not-Equal 연산 지원
			XCTAssert(stack1 != stack2)
			
			/// Test failed - 3. ===, !== 연산 지원
			XCTAssert(stack1 === stack2)
		}
	}
	```


### Swift 의 Pointer 정리

### why?

Swift 2.x 버전에서 3.x 대로 넘어오면서 가장 많은 변경이 있던 부분중 하나가 Pointer 관련된 사항일 것이다.

일반적으로 swift 에서 pointer 관련된 처리를 하는 경우는 거의(?) 없을것이다. 하지만 다음과 같은 경우라면 관련된 처리가 필요할것이다.

* 기존의 C, C++ 로 작성된 라이브러리 사용하는 경우.
	- socket 통신을 통해 받은 데이타(buffer 가 포인터인 경우)를 iOS/MacOS 환경에 맞게 변환이 필요.
		
* 보안 관련 라이브러리 사용하는 경우.
	- 대부분 C, C++ 로 작성되어 있는것 같다. 따라서 buffer 를 포인터 기반으로 처리한다.

* 서버에 데이타를 EUC-KR encoding 으로  전송할 때 다음과 같이 처리가 필요할것 이다.

	- UTF8 -> EUC-KR 로 encoding 변환

	- 전달될 데이타를 buffer 에 전달(복사 하거나 참조 포인터를 전달)
	
	- UTF8 -> EUC-KR -> UTF8 로 변환하는 예제	
	- String.Encoding 에는 EUC-KR 이 포함되어 있지 않아 기존에 사용하던 **CFStringConvertEncodingToNSStringEncoding(0x0422)** 을 그대로 이용했다.

~~~swift
	
	let content = "가수 비(정지훈)와 배우 김태희가 동료 스타들의 축복 속 부부의 연을 맺었다.\n\n비와 김태희는 19일 오후 2시 서울 종로구 가회동 성당에서 혼배미사를 올리고 부부로 첫 걸음을 내딛었다. 지난 2011년 처음 만나 연인으로 발전한 두 사람은 이로써 열애 5년여 만에 사랑의 결실을 맺게 됐다."
	
	let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
	
	let size = content.lengthOfBytes(using: String.Encoding(rawValue: encodingEUCKR)) + 1
	
	var buffer: [CChar] = [CChar](repeating: 0, count: size)
	
	/// UTF8 -> EUC-KR 로 변환
	let result = strData.getCString(&buffer, maxLength: size, encoding: String.Encoding(rawValue: encodingEUCKR))

	print(buffer)
	print(buffer.count)
	// output : [-80, -95, -68, ... , -39, 46, 0]
	// output : 272 byte
	
	
	/// EUC-KR -> UTF8 로 변환
	let data = Data(bytes: buffer, count: size)
	let strUTF8 = String(data: data, encoding: String.Encoding(rawValue: encodingEUCKR))
	
	print(strUTF8)

~~~

이 앞의 Encoding 예제에서 처럼 우리는 알게 모르게 포인터 처리를 했다. 바로 getCString(), Data(bytes:count) 와 같은 함수였다.

~~~swift
String.getCString(_ buffer: inout [CChar], maxLength: Int, encoding: String.Encoding) -> Bool
Data.init(bytes: UnsafeRawPointer, count: Int)
~~~

그럼 Swift 가 준비해둔 Pointer 관련된 구조체는 어떤것이 있는가??? 

이에 대해 잘 정리된 [Unsafe Swift: Using Pointers And Interacting With C](https://www.raywenderlich.com/148569/unsafe-swift) 글이 있으니 참고하자.


### 정리


1. Pointer 관련 Type 추가


	|Swift 2.x        | Swift 3.x |
	|:---------------:|:---------------:|
	UnsafeMutablePointer<T>       | 	UnsafeMutablePointer<T>
	UnsafePointer<T>              | UnsafePointer<T>
	UnsafeMutableBufferPointer<T> | UnsafeMutableBufferPointer<T>
	UnsafeBufferPointer<T>        | UnsafeBufferPointer<T>
	 X | **UnsafeMutableRawPointer**
	 X | **UnsafeRawPointer**
	 X | **UnsafeMutableRawBufferPointer**
	 X | **UnsafeRawPointer** 
	 
2. Unsafe[Mutable]Pointer 접근 변경

	2.x 대에서 memory property 에서 3.x 대에서는 pointee property 로 접근

3. Pointer 관련 function 변화

	|Swift 2.x        | Swift 3.x |
	|:---------------:|:---------------:|
unsafeAddressOf | **X**
unsafeBitCast | unsafeBitCast
unsafeDowncast | unsafeDowncast
unsafeUnwrap | **X**
withUnsafeMutablePointer | withUnsafeMutablePointer
withUnsafeMutablePointers | **X**
withUnsafePointer | withUnsafePointer
withUnsafePointers | **X**
 
4. Swift 3.x Pointer Type 별 비교 Table
![raywenderlich pointer tables](https://github.com/hyuni/Blog-Swift/raw/master/Content/image/swift_pointer_types_table.png)



### reference
* [Swift version 별 Document](http://swiftdoc.org)
 
* [Swift Evolution 0107: UnsafeRawPointer API](https://github.com/apple/swift-evolution/blob/master/proposals/0107-unsaferawpointer.md)

* [Swift Evolution 0138: UnsafeRawBufferPointer API](https://github.com/apple/swift-evolution/blob/master/proposals/0138-unsaferawbufferpointer.md)

* [Unsafe Swift: Using Pointers And Interacting With C](https://www.raywenderlich.com/148569/unsafe-swift)

* [iOS에서 EUC-KR NSString으로 디코딩하기
](http://leejong.org/entry/iOS%EC%97%90%EC%84%9C-EUCKR-NSString%EC%9C%BC%EB%A1%9C-%EB%94%94%EC%BD%94%EB%94%A9%ED%95%98%EA%B8%B0)


### Enumeration 의 모든 요소 구하기

### why

1. 기본적으로 enumeration 의 모든 항목을 구하기 위해 다음과 같이 사용한다.

	~~~swift
	enum CompassPoint {
		case north
		case south
		case east
		case west
	
		static let allValues: [CompassPoint] = [north, south, east, west]
	
	}
	~~~

2. 하지만 case 가 무수이 많다면? 혹은 작성해야 할 enumeration 이 무수이 많다면? 우리는 손 노가다(?)를 해야 할까??

	> 기존에 Objective-C 로 구현된 framework 와 이를 이용하기 위한 header 파일을 받은적이 있다.

	> 아래와 같이 Objective-C 로 선언된 enum 을 swift 에서 그대로 사용할 방법이 없어서 warpper enum 파일을 작성한 적이 있다.
	
	> 하나의 header 파일안에 무수이 선언된 enum, 거기에  allValues 같은걸 추가한다고 생각하면... 끔찍하다.
	
	
	~~~objc
	// 아래와 같이 objective-c 의 enum 만으로 선언할 경우 swift 에서 그대로 사용이 불가능하다.
	typedef enum: NSInteger {
		kCircle = 1
		kRectangle
		kOblateSpheroid
		// ...
	} ShapeType
	
	
	// NS_ENUM 으로 선언된 경우에는 swift 에서 그대로 사용이 가능하다.
	typedef NS_ENUM(NSInteger, ShapeType) {
		// ...
	}
	~~~


### how

1. 실패한 방법
	
	> 처음에는 swift 의 reflection 으로 접근할 수 없을까? 란 생각으로 코드를 작성해봤으나 불가능했다. ㅠㅜ 
	
	
2. 구글 검색을 통해 찾은 방법
	* 첫번째 (유연하지 못함)
	
	> 시작 Index 가 0 으로 fix 됨. ==> 음수값을 적용할 수 없음
	
	> 증감값이 1로 fix 됨. ==>  1 씩 증가되지 않거나  중간 중간 건너띈다면 모든 요소를 제대로 구할 수 없음

	~~~swift
	protocol EnumCollection: RawRepresentable {
		static var allValues: [Self] { get }
	}
	
	extension EnumCollection where RawValue: Integer {
		static var allValues: [Self] {
			var index: Self.RawValue = 0
			let increment: Self.RawValue = 1
			
			return Array(AnyIterator {
				let id: Self.RawValue = index
				index += increment
				return Self(rawValue: id)
			})
		}
	}
	
	enum CompassPoint: Int, EnumCollection {
		case north
		case south
		case east
		case west
	}
	
	// outputs : [CompassPoint.north, CompassPoint.south, CompassPoint.east, CompassPoint.west]
	print(CompassPoint.allValues)

	~~~
	
	* 두번째 
	
	> Hashable protocol 을 지원하는 Integer, Double 등 거의 모든 Type 이 가능하다.
	
	
	~~~swift
	protocol EnumCollection: Hashable {
		static var allValues: [Self] { get }
	}

	extension EnumCollection {
		static func cases() -> AnySequence<Self> {
			typealias S = Self
		
			return AnySequence { () -> AnyIterator<S> in
				var raw = 0
				
				return AnyIterator {
					let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
					guard current.hashValue == raw else { return nil }
					raw += 1
					return current
				}
			}
		}
    
		static var allValues: [Self] {
			return Array(self.cases())
		}
	}

	enum CompassPoint: Int, EnumCollection {
		case north
		case south
		case east
		case west
	}

	// outputs : [CompassPoint.north, CompassPoint.south, CompassPoint.east, CompassPoint.west]
	print(CompassPoint.allValues)
	
	~~~
	
	
### 참고


* [How to enumerate an enum with String type?](http://stackoverflow.com/questions/24007461/how-to-enumerate-an-enum-with-string-type/24137319#24137319)	
* [generic allValues for enums](https://theswiftdev.com/2017/01/05/18-swift-gist-generic-allvalues-for-enums/)
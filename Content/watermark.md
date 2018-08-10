## watermark

### why?

프로젝트를 진행하면서 Content 화면에 일괄적으로 [Watermark](https://ko.wikipedia.org/wiki/%EC%9B%8C%ED%84%B0%EB%A7%88%ED%81%AC) 를 적용해달라는 요구사항을 받았다. 또한 Watermark 문자를 -45도 회전하여 달라는 요구사항도 있었다.

기존에 적용된 autolayout 에 쉽게(?layout 변경 없이) 적용할수 있는 방법으로 화면의 맨 위에 사용자 입력을 받지 않는 이미지(또는 ImageView) 를 적용하면 될듯싶다.

문제는 iOS 에서 제공하는 Core Graphics 가 많이 사용해보지 않아 익숙치 않다는것이다.

### how?

XCode 를 실행하고, Playground 를 선택하고 Single View 기반으로 프로젝트를 생성한다.

1. 가장 먼저 선행되어야 하는것은 Watermark 문자열을 받아 이미지 만들어, ImageView 에 출력해 보는 것이다.
우선은 Image 를 리턴하는 함수부터 작성해본다.

```swift
func watermark(_ rect: CGRect, text: String) -> UIImage {
	let renderer = UIGraphicsImageRenderer(bounds: rect)
		
	let image = renderer.image { (context) in
			
	}
		
	return image
}
```

만들어진 image 를 출력하기 위해 ImageView 를 만들어 여기에 watermark(_::) 함수로 만들어진 이미를 출력하는 코드는 아래와 같다.
live View 를 통해 확인하면 화면 중앙쯤에 노란색의 박스가 ImageView 이고, 현재 watermark(_::) 로 만든 이미지는 아무것도 하지 않아 투명도(UIColor.clear) 가 적용된 상태이다.
(따라서 배경색으로 적용한 yellow 의 박스가 나타난다)


```swift
class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let imageView = UIImageView(frame: .zero)
        imageView.frame = CGRect(x: 100, y: 200, width: 200, height: 100)
		imageView.backgroundColor = .yellow
		
		let watermarkImage = watermark(imageView.bounds, text: "WaterMark")
		imageView.image = watermarkImage
		
        view.addSubview(imageView)
		
		
        self.view = view
    }
	
	func watermark(_ rect: CGRect, text: String) -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: rect)
		
		let image = renderer.image { (context) in
			
		}
		
		return image
	}
}
```

다음으로 이제 watermark(_::) 의 인자인 text 를 그려주어야 한다. 하지만 swfit 가 제공하는 String 객체에는 draw() 함수를 찾을수가 없다. 다만, NSString 객체에는 아래와 같은 draw() 함수를 제공한다.

draw(at::) 함수는 지정 포인트에 문자열을 그려주고,
draw(in::) 함수는 주어진 영역에 문자열을 그려준다.
그리고 마지막으로 draw(with::::) 함수는 주어진 영역, drawing Options 를 적용하여 문자열을 그려준다.


```swift
func draw(at: CGPoint, withAttributes: [NSAttributedStringKey : Any]? = nil)
Draws the receiver with the font and other display characteristics of the given attributes, at the specified point in the current graphics context.

func draw(in: CGRect, withAttributes: [NSAttributedStringKey : Any]? = nil)
Draws the attributed string inside the specified bounding rectangle.

func draw(with: CGRect, options: NSStringDrawingOptions = [], attributes: [NSAttributedStringKey : Any]? = nil, context: NSStringDrawingContext?)
Draws the attributed string in the specified bounding rectangle using the provided options.
```

아래와 같이 코드를 적용하면 ImageView 상단에 검은색으로 "WaterMark" 출력되는것을 확인할수 있다. 

```swift
	func watermark(_ rect: CGRect, text: String) -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: rect)
		
		let image = renderer.image { (context) in
			(text as NSString).draw(at: CGPoint(x: 0, y: 0), withAttributes: nil)
		}
		
		return image
	}
```


다시 Image 중앙으로 다음과 같이 변경해본다. 

```swift
	func watermark(_ rect: CGRect, text: String) -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: rect)
		
		let image = renderer.image { (context) in
			(text as NSString).draw(at: CGPoint(x: rect.width / 2.0, y: rect.height / 2.0), withAttributes: nil)
		}
		
		return image
	}
```


중앙에서 오른쪽 하단으로 조금 치우쳐 있다. "WaterMark" 가 출력되는 Size 를 알아보면 (width: 58.23, height: 13.8) 을 얻을수 있다. 이를 가지고 중앙에 위치하도록 코드를 변경한다.

```swift
	func watermark(_ rect: CGRect, text: String) -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: rect)
		
		let image = renderer.image { (context) in
			
			let size = (text as NSString).size(withAttributes: nil)
			
			(text as NSString).draw(at: CGPoint(x: (rect.width - size.width) / 2.0, y: (rect.height - size.height) / 2.0), withAttributes: nil)
		}
		
		return image
	}
```

이제 두번째로 "WaterMark" 문구를 -45 도 회전하여 출력하여야 한다. 아래와 같이 회전하여 출력되는지 확인해 본다.
화면에 "WaterMark" 가 출력되어 있지 않다. 원점(0, 0) 적용되어 회전하였기에 영역 밖에 출력된것으로 생각된다.

```swift
	func watermark(_ rect: CGRect, text: String) -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: rect)
		
		let image = renderer.image { (context) in
			
			let size = (text as NSString).size(withAttributes: nil)

			let angle = CGFloat(-45) * .pi / 180
			
			context.cgContext.rotate(by: angle)
			
			(text as NSString).draw(at: CGPoint(x: (rect.width - size.width) / 2.0, y: (rect.height - size.height) / 2.0), withAttributes: nil)
		}
		
		return image
	}
```

회전을 하는 원점을 변경하기 위해 아래와 같이 코드를 수정한다. 

```swift
	func watermark(_ rect: CGRect, text: String) -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: rect)
		
		let image = renderer.image { (context) in
			
			let size = (text as NSString).size(withAttributes: nil)

			let angle = CGFloat(-45) * .pi / 180

			context.cgContext.translateBy(x: rect.width / 2.0, y: rect.height / 2.0)
			context.cgContext.rotate(by: angle)
			
			(text as NSString).draw(at: CGPoint(x: (rect.width - size.width) / 2.0, y: (rect.height - size.height) / 2.0), withAttributes: nil)
		}
		
		return image
	}
```

화면에 표시가 되지만 우측 끝에 살짝 걸쳐 출력된다. draw(at::) 함수의 좌표가 원점을 변경하면서 적용된것 같다. 다시 정상적으로 출력되도록 아래와 같이 수정한다.

```swift
	func watermark(_ rect: CGRect, text: String) -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: rect)
		
		let image = renderer.image { (context) in
			
			let size = (text as NSString).size(withAttributes: nil)

			let angle = CGFloat(-45) * .pi / 180

			context.cgContext.translateBy(x: rect.width / 2.0, y: rect.height / 2.0)
			context.cgContext.rotate(by: angle)
			
			let point = CGPoint(x: 0.0 - (size.width / 2.0), y: 0.0 - (size.height / 2.0))
			(text as NSString).draw(at: point, withAttributes: nil)
		}
		
		return image
	}
```

워터마크를 출력하는 [playground 샘플]() 을 압축하여 올려두었다.


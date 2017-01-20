## DimView vs VisualEffectView

### why?

1. DimView?

* [dim 의 사전적 의미](http://dic.daum.net/search.do?q=dim)는 다음 사전에서 검색한 결과 다음과 같다.

		> 1.어두운2.조명을 줄이다3.불투명한4.우둔한

		> iOS 모바일 앱에서 dimView 는 **서버에 어떤 요청을 하고 응답을 받기까지 사용자의 입력을 제한하고, 이를 사용자에게 알리는 목적** 의 용도로 많이 사용된다.
		
* 샘플 - 일반적인 사용 방법은 다음과 같다.

	~~~swift
	// UIViewController 에서 dim View 생성후 적용하는 방법.
	func showDimView() {

		// ViewController 의  크기와 동일하게 dimView 생성
		let dimView = UIView(frame: self.view.frame)
		
		// 일반적으로 alpha 값이 0.666666 정도이다.
		dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		
		// 사용자 입력을 제한하기 위해 사용되나.
		// tap, swipe, long press, pan 등을 막으면 된다.
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTappedGesture(sender:)))
		
		dimView.addGestureRecognizer(tapGesture)
		
		// UIViewController 의 맨 앞에 위치하도록 추가한다.
		self.view.insertSubView(dimView, at: 0)
	}
	~~~
	
2. UIVisualEffectView

- iOS 8 SDK 부터 제공되고 있다.
- UIBlurEffect, UIVibrancyEffect 를 적용시킬수 있다.
- UiBlurEffect Style은 다음과 같이 세가지를 제공한다.

	~~~swift
	case extraLight
	case light
	case dark
	~~~

- 샘플 - UIViewController 에 blur Effect 적용 예제.

	~~~swift	
	func showVisualEffectView() {
	
		// light blur 를 적용시킨 VisualEffectView 생성
		let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		
		// ViewController 의  크기와 동일하게 dimView 생성
		blurView.frame = self.view.frame
	
		// UIViewController 의 맨 앞에 위치하도록 추가한다.
		self.view.insertSubView(blurView, at: 0)
	}
	~~~
		
### how

- Blur Effect 를  UIViewController 에 extension 으로 적용.

	~~~swift
    extension UIViewController {
        public var blurView: UIVisualEffectView! {
            get {
                if let view = self.blurView {
                    return view
                }
                
                let width = UIScreen.main.bounds.width
                let height = UIScreen.main.bounds.height
                
                self.blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
                
                self.blurView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
                
                return self.blurView
            }
            
            set {
                self.blurView = nil
                self.blurView = newValue
            }
        }
        
        public var isShowBlurView: Bool {
            get {
                return self.isShowBlurView
            }
            
            set {
                self.isShowBlurView = newValue
            }
        }
        
        public func showBlurView() {
            guard let blurView = self.blurView, self.isShowBlurView == false else {
                return
            }
            
            if let delegate = UIApplication.shared.delegate, let window = delegate.window {
                
                window?.insertSubview(blurView, at: 0)
                
            }
            
            self.isShowBlurView = true
        }
        
        public func hideDimView() {
            guard let blurView = self.blurView, self.isShowBlurView == true else {
                return
            }
            
            if let delegate = UIApplication.shared.delegate, let window = delegate.window {
                blurView.removeFromSuperview()
            }
            self.isShowBlurView = false
        }
    }
	~~~

### reference

### tag
	swift, DimView, VisualEffect, UIVisualEffectView, Blur, UIBlurEffect
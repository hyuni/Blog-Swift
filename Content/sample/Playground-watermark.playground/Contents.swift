//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

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
			
			let size = (text as NSString).size(withAttributes: nil)

			let angle = CGFloat(-45) * .pi / 180

			context.cgContext.translateBy(x: rect.width / 2.0, y: rect.height / 2.0)
			context.cgContext.rotate(by: angle)
			
			let point = CGPoint(x: 0.0 - (size.width / 2.0), y: 0.0 - (size.height / 2.0))
			(text as NSString).draw(at: point, withAttributes: nil)
		}
		
		return image
	}
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

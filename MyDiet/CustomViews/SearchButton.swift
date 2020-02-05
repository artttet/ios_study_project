import UIKit

class SearchButton: UIButton {
    
    var imageTintColor: UIColor = UIColor(named: "primaryColor")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                touchDown()
            } else {
                touchUp()
            }
        }
    }
    
    func touchDown() {
        let imageView = subviews.first
        imageView?.tintColor = imageTintColor.withAlphaComponent(0.6)
    }
    
    func touchUp() {
        let imageView = subviews.first
        imageView?.tintColor = imageTintColor
    }
    
}

import UIKit

class SearchButton: UIButton {
    
    var subviewColor: UIColor = UIColor(named: "primaryColor")!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let subview = subviews.first as? UIImageView {
            subviewColor = subview.tintColor
        }
        
        if let subview = subviews.first as? UILabel {
            subviewColor = subview.textColor
        }
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
        if let subview = subviews.first as? UIImageView {
            subview.tintColor = subviewColor.withAlphaComponent(0.6)
        }
        
        if let subview = subviews.first as? UILabel {
            subview.textColor = subviewColor.withAlphaComponent(0.6)
        }
    }
    
    func touchUp() {
        if let subview = subviews.first as? UIImageView {
            subview.tintColor = subviewColor
        }
        
        if let subview = subviews.first as? UILabel {
            subview.textColor = subviewColor
        }
    }
    
}

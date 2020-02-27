import UIKit
import FSPagerView
import BEMCheckBox

class CardsPagerView: FSPagerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        transformer = FSPagerViewTransformer(type: .linear)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

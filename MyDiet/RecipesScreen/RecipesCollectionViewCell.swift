import UIKit

class RecipesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var bottomConstraint: NSLayoutConstraint!
    
    var index: Int = -1
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0))
    }
    
    func setData(index: Int) {
        self.index = index
        setupView()
    }
    
    func setupView() {
        if index == 0 {
            contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0))
            //topConstraint.constant = 24
            //bottomConstraint.constant = -12
        }
        
        mainView.layer.cornerRadius = 14
        imageView.layer.cornerRadius = 14
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
//        mainView.layer.shadowColor = UIColor(named: "primaryColor")?.cgColor
//        mainView.layer.shadowRadius = 5
//        mainView.layer.shadowOffset = CGSize(width: 0, height: 5)
//        mainView.layer.shadowOpacity = 1
    }
    
}

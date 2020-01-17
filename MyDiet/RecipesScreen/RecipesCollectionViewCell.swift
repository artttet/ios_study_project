import UIKit

protocol RecipesCollectionViewCellDelegate: AnyObject {
    func recipesCollectionViewCellDidTap(_ collectionViewCell: RecipesCollectionViewCell)
}

class RecipesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet var imageView: UIImageView!
   
    lazy var tap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.hearthTapped(_:)))
        return t
    }()
    
    var index: Int = -1
    weak var delegate: RecipesCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //self.button.addTarget(self, action: #selector(self.hearthTapped(_:)), for: .touchUpInside)
        
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc
    func hearthTapped(_ sender: UITapGestureRecognizer) {
        print("hearth")
        self.delegate?.recipesCollectionViewCellDidTap(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.removeFromSuperview()
    }
    
    func setData(index: Int) {
        self.index = index
        setupView()
    }
    
    func setupView() {
        imageView.layer.cornerRadius = 14
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    
}

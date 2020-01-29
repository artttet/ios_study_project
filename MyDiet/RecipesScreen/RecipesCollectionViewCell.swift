import UIKit

protocol RecipesCollectionViewCellDelegate: AnyObject {
    func recipesCollectionViewCellDidTap(_ collectionViewCell: RecipesCollectionViewCell)
}

class RecipesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeCategory: UILabel!
    
//    lazy var tap: UITapGestureRecognizer = {
//        let t = UITapGestureRecognizer(target: self, action: #selector(self.hearthTapped(_:)))
//        return t
//    }()
    
    var index: Int = -1
    
    weak var delegate: RecipesCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = 14
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        imageView.isUserInteractionEnabled = true
        //imageView.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.removeFromSuperview()
    }
    
    func setupView() {
        
    }
    
}

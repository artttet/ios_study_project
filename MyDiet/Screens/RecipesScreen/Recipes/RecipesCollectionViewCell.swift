import UIKit

protocol RecipesCollectionViewCellDelegate {
    func viewTapped(_ collectionViewCell: RecipesCollectionViewCell)
}

class RecipesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeCategory: UILabel!
    @IBOutlet var view: GradientView!
    @IBOutlet var moreView: UIImageView!
    
    lazy var tap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(_:)))
        return t
    }()
    
    var delegate: RecipesCollectionViewCellDelegate?
    
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.removeFromSuperview()
    }
    
    @objc
    func viewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.viewTapped(self)
    }
    
    func setupView() {
        moreView.isUserInteractionEnabled = true
        moreView.addGestureRecognizer(tap)
        
        imageView.layer.cornerRadius = 14
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}

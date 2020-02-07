import UIKit

protocol RecipesCollectionViewCellDelegate {
    func viewTapped(_ collectionViewCell: RecipesCollectionViewCell)
}

class RecipesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeCategory: UILabel!
    @IBOutlet var view: GradientView!
    
    @IBAction func moreButtonAction(_ sender: Any) {
        delegate?.viewTapped(self)
    }
    
    var delegate: RecipesCollectionViewCellDelegate?
    
    var index: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.removeFromSuperview()
    }
    
    func setupView() {
        imageView.layer.cornerRadius = 14
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}

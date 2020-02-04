import UIKit

class RecipesCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var recipeNameLabel: UILabel!
    @IBOutlet var recipeCategory: UILabel!
    
    var index: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView() {
        imageView.layer.cornerRadius = 14
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        imageView.isUserInteractionEnabled = true
    }
}

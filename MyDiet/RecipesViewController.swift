import UIKit

class RecipesViewController: UIViewController {

    
    @IBOutlet var iconSearch: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    var style: UIStatusBarStyle = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        
        let image = UIImage(named: "search")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconSearch.setImage(tintedImage, for: .normal)
        iconSearch.tintColor = UIColor(named: "primaryColor")

    }

}

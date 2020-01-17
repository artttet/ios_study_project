import UIKit

class RecipesViewController: UIViewController {
    
    @IBOutlet var iconSearch: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    var style: UIStatusBarStyle = .default
    
    override func viewDidLoad() {
        
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        collectionView.register(UINib(nibName: "RecipesCollectionViewCell", bundle: Bundle(identifier: "RecipesCollectionViewCell")), forCellWithReuseIdentifier: "RecipesCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 8, right: 0)
        
        
        let image = UIImage(named: "search")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconSearch.setImage(tintedImage, for: .normal)
        iconSearch.tintColor = UIColor(named: "primaryColor")
        super.viewDidLoad()

    }
}

extension RecipesViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCollectionViewCell", for: indexPath) as! RecipesCollectionViewCell
        cell.setData(index: indexPath.row)
        cell.delegate = self
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width
        let height = CGFloat.init(112.0)
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension RecipesViewController: RecipesCollectionViewCellDelegate {
    
    func recipesCollectionViewCellDidTap(_ collectionViewCell: RecipesCollectionViewCell) {
        print("recipesCollectionViewCellDidTap")
    }
}

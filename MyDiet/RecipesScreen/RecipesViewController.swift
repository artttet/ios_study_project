import UIKit

class RecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = collectionView.frame.size.height * 0.25
        return CGSize(width: width, height: height)
    }
    
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCollectionViewCell", for: indexPath) as! RecipesCollectionViewCell
        return cell
    }
    

    
    @IBOutlet var iconSearch: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    var style: UIStatusBarStyle = .default
    
    override func viewDidLoad() {
        
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        collectionView.register(UINib(nibName: "RecipesCollectionViewCell", bundle: Bundle(identifier: "RecipesCollectionViewCell")), forCellWithReuseIdentifier: "RecipesCollectionViewCell")
        
        
        let image = UIImage(named: "search")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconSearch.setImage(tintedImage, for: .normal)
        iconSearch.tintColor = UIColor(named: "primaryColor")
        super.viewDidLoad()

    }

}

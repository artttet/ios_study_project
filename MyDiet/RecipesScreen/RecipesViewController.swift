import UIKit

class RecipesViewController: UIViewController {
    @IBOutlet var iconSearch: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var plusButtonView: PlusRecipeButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    
    var style: UIStatusBarStyle = .default
    
    var buttonState = -1;
    
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

extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCollectionViewCell", for: indexPath) as! RecipesCollectionViewCell
        
        cell.delegate = self
        
        return cell
    }
}

extension RecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func temp(_ state: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .beginFromCurrentState, animations: {
            var plusButtonFrame = self.plusButtonView.frame
            if state == true {
                plusButtonFrame.origin.y -= plusButtonFrame.size.height+24
            } else {
                plusButtonFrame.origin.y += plusButtonFrame.size.height+24
            }
            
            self.plusButtonView.frame = plusButtonFrame
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(buttonState)
        if collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
            if buttonState == 0 {
                temp(true)
            }
            buttonState = 1
        } else if buttonState == 1 {
            if buttonState == 1 {
                temp(false)
            }
            buttonState = 0
        }
    }
}

extension RecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width
        let height = CGFloat.init(112.0)
        
        return CGSize(width: width, height: height)
    }
}

extension RecipesViewController: RecipesCollectionViewCellDelegate {
    
    func recipesCollectionViewCellDidTap(_ collectionViewCell: RecipesCollectionViewCell) {
        print("recipesCollectionViewCellDidTap")
    }
}

import UIKit

class RecipesViewController: UIViewController {
    @IBOutlet var iconSearch: UIButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var plusButtonView: PlusRecipeButton!
    
    var style: UIStatusBarStyle = .default
    
    var plusButtonState = -1;
    
    var recipeList: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        recipeList = RecipesScreenDataManager.instance.getRecipeList(withSortKey: "name")
        
        collectionView.register(UINib(nibName: "RecipesCollectionViewCell", bundle: Bundle(identifier: "RecipesCollectionViewCell")), forCellWithReuseIdentifier: "RecipesCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 8, right: 0)
        
        let image = UIImage(named: "search")
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconSearch.setImage(tintedImage, for: .normal)
        iconSearch.tintColor = UIColor(named: "primaryColor")
        
        plusButtonView.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecipesCollectionView(_:)), name: .init(Notifications.UpdateRecipesCollectionView.rawValue), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .init(Notifications.UpdateRecipesCollectionView.rawValue), object: nil)
    }
    
    @objc
    func plusButtonTapped(_ sender: PlusRecipeButton) {
        let destinationVC = AddRecipeViewController(nibName: "AddRecipeViewController", bundle: nil)
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    @objc
    func updateRecipesCollectionView(_ notification: Notification) {
        recipeList = RecipesScreenDataManager.instance.getRecipeList(withSortKey: "name")
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCollectionViewCell", for: indexPath) as! RecipesCollectionViewCell
        
        let category = recipeList[indexPath.row].category
        cell.recipeNameLabel.text = recipeList[indexPath.row].name
        cell.recipeCategory.text = category
        
        var image = UIImage()
        if category == "Завтрак" {
            image = UIImage(named: "breakfast.jpg")!
        }
        if category == "Обед" {
            image = UIImage(named: "dinner.jpg")!
        }
        if category == "Ужин" {
            image = UIImage(named: "dinner2.jpg")!
        }
        
        cell.imageView.image = image
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func showPlusButton(_ state: Bool) {
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
        if collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
            if plusButtonState == 0 {
                showPlusButton(true)
            }
            plusButtonState = 1
        } else if plusButtonState == 1 {
            if plusButtonState == 1 {
                showPlusButton(false)
            }
            plusButtonState = 0
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension RecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width
        let height = CGFloat.init(112.0)
        
        return CGSize(width: width, height: height)
    }
}


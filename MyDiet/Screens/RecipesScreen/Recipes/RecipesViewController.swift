import UIKit

class RecipesViewController: UIViewController {
    @IBOutlet var iconSearch: MyButton!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var plusButtonView: PlusRecipeButton!
    @IBOutlet var needRecipeLabel: UILabel!
    @IBOutlet var recipesLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var xmark: UIImageView!
    @IBOutlet var topBackgroundView: UIView!
    
    @IBOutlet var iconSearchViewConstraintRight: NSLayoutConstraint!
    
    @IBAction func iconSearchAction(_ sender: Any) {
        
        if !searchIsOpen {
            openSearch()
        } else {
            textField.resignFirstResponder()
        }
    }
    
    lazy var xmarkAction: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(xmarkTapped))
        return t
    }()
    
    var iconSearchViewConstraintLeft: NSLayoutConstraint!
    
    var searchIsOpen: Bool = false
    
    var iconSearchOriginX: CGFloat = 0
    
    var style: UIStatusBarStyle = .default
    
    var isNeedPlusButtonShow = false;
    
    var recipeList: [Recipe] = []
    
    var fullRecipeList: [Recipe] = []
    
    var recipePageViewController: RecipePageViewController?
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        xmark.isUserInteractionEnabled = true
        xmark.addGestureRecognizer(xmarkAction)
        
        updateRecipesCollectionView(nil)
        
        
        collectionView.register(UINib(nibName: "RecipesCollectionViewCell", bundle: Bundle(identifier: "RecipesCollectionViewCell")), forCellWithReuseIdentifier: "RecipesCollectionViewCell")
        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 8, right: 0)
        
        textField.delegate = self
        textField.attributedPlaceholder = NSAttributedString(string: "Название рецепта", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        plusButtonView.addTarget(self, action: #selector(plusButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        recipePageViewController = RecipePageViewController()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecipesCollectionView(_:)), name: .init(Notifications.UpdateRecipesCollectionView.rawValue), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .init(Notifications.UpdateRecipesCollectionView.rawValue), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let contraint = iconSearchViewConstraintLeft {
            return
        } else {
            iconSearchViewConstraintLeft = iconSearch.leadingAnchor.constraint(equalTo: topBackgroundView.leadingAnchor
            , constant: 32)
        }
    }
    
    @objc
    func plusButtonTapped(_ sender: PlusRecipeButton) {
        let destinationVC = AddRecipeViewController(nibName: "AddRecipeViewController", bundle: nil)
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    @objc
    func updateRecipesCollectionView(_ notification: Notification?) {
        recipeList = RecipesScreenDataManager.instance.getRecipeList(withSortKey: "name")
        
        fullRecipeList = recipeList
        
        if recipeList.count == 0 {
            needRecipeLabel.isHidden = false
        } else {
            needRecipeLabel.isHidden = true
        }
    
        self.collectionView.reloadData()
    }
    
    func deleteCell(at index: Int) {
        RecipesScreenDataManager.instance.deleteRecipe(at: index, withSortKey: "name")
        updateRecipesCollectionView(nil)
    }
}

// MARK: - Search Functions
extension RecipesViewController {
    
    @objc
    func xmarkTapped() {
        if textField.text!.isEmpty {
            textField.resignFirstResponder()
            closeSearch()
        } else {
            textField.text = nil
            textField.becomeFirstResponder()
            
            recipeList = fullRecipeList
            needRecipeLabel.text = "Необходимо добавить хотя бы один рецепт..."
            
            if recipeList.count == 0 {
                needRecipeLabel.isHidden = false
            } else {
                needRecipeLabel.isHidden = true
            }
            
            collectionView.reloadData()
        }
    }
    
    func openSearch() {
        searchIsOpen = true
        
        fullRecipeList = recipeList
        
        iconSearchOriginX = iconSearch.frame.origin.x
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [ .curveEaseOut],
            animations: {
                self.iconSearch.frame.origin.x = self.recipesLabel.frame.origin.x
                
                self.recipesLabel.isHidden = true
            }, completion: { _ in
                self.textField.becomeFirstResponder()
                
                self.textField.isHidden = false
                self.xmark.isHidden = false
            
                //self.iconSearchViewConstraintLeft.isActive = true
                self.iconSearchViewConstraintRight.isActive = false
            }
        )
    }

    func closeSearch() {
        
        recipeList = fullRecipeList
        collectionView.reloadData()
        
        searchIsOpen = false
        
        self.textField.text = nil
        self.textField.isHidden = true
        self.xmark.isHidden = true
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0.0,
            options: [ .curveEaseIn],
            animations: {
                
                self.iconSearch.frame.origin.x = self.iconSearchOriginX
            }, completion: { _ in
                self.recipesLabel.isHidden = false
                
                self.iconSearchViewConstraintLeft.isActive = false
                self.iconSearchViewConstraintRight.isActive = true
            }
        )
    }
}

// MARK: - UICollectionViewDataSource
extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipesCollectionViewCell", for: indexPath) as! RecipesCollectionViewCell
        
        cell.delegate = self
        
        cell.index = indexPath.row
        cell.recipeNameLabel.text = recipeList[indexPath.row].name
        let category = recipeList[indexPath.row].category
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
        recipePageViewController?.recipe = recipeList[indexPath.row]

        recipePageViewController?.modalPresentationStyle = .fullScreen
        self.present(recipePageViewController!, animated: true, completion: nil)
        
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
    
    @objc
    func plusButtonShowCheck() {
        if collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
            if isNeedPlusButtonShow {
                showPlusButton(true)
                isNeedPlusButtonShow = false
            }
        } else {
            if recipeList.count == 0 {
                showPlusButton(true)
                isNeedPlusButtonShow = false
            }
            if !isNeedPlusButtonShow {
                showPlusButton(false)
                isNeedPlusButtonShow = true
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        perform(#selector(plusButtonShowCheck), with: nil, afterDelay: 0.0)
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

// MARK: - RecipesCollectionViewCellDelegate
extension RecipesViewController: RecipesCollectionViewCellDelegate {
    func viewTapped(_ collectionViewCell: RecipesCollectionViewCell) {
        
        let alert = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Редактировать", style: .default, handler: { action in
            
        }))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { action in
            self.deleteCell(at: collectionViewCell.index)
        }))
        
        alert.view.tintColor = UIColor(named: "primaryColor")
        self.present(alert, animated: true)
    }
}

// MARK: - UITextFiledDelegate
extension RecipesViewController: UITextFieldDelegate {
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        recipeList.removeAll()
        
        if textField.text!.isEmpty {
            recipeList = fullRecipeList
            
        } else {
            fullRecipeList.forEach({ recipe in
                if let name = recipe.name {
                    if name.lowercased().contains(textField.text!.lowercased()) {
                        recipeList.append(recipe)
                    }
                }
            })
        }
        
        if !textField.text!.isEmpty {
            if recipeList.count == 0 {
                needRecipeLabel.text = "Рецепты не найдены"
                needRecipeLabel.isHidden = false
            } else {
                needRecipeLabel.isHidden = true
            }
        } else {
            needRecipeLabel.text = "Необходимо добавить хотя бы один рецепт..."
            if recipeList.count != 0 {
                needRecipeLabel.isHidden = true
            }
        }
        
        collectionView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        
        return true
    }
    
}

import UIKit

class RecipesViewController: UIViewController {
    
    // MARK: - Views
    let recipesLabel: UILabel = {
        let label = UILabel()
        label.text = .localized("Recipes")
        label.textColor = .primary
        label.font = .screenTitle
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let searchButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .background
        button.tintColor = .primary
        
        let image = UIImage(systemName: "magnifyingglass")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(.buttonImageConfiguration, forImageIn: .normal)
        
        button.addTarget(self, action: #selector(searchButtonDidTap), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let searchTextField: UITextField = {
        let field = UITextField()
        field.placeholder = .localized("Name_of_recipe")
        field.textColor = .primary
        field.tintColor = .primary
        field.backgroundColor = .background
        field.borderStyle = .none
        field.autocorrectionType = .no
        
        field.alpha = 0.0
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    let closeSearchButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.backgroundColor = .background
        button.tintColor = .placeholderText
        
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(closeSearchButtonDidTap), for: .touchUpInside)
        
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .background
        collection.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 8, right: 0)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    let addRecipeButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.tintColor = .white
        button.backgroundColor = .accent
        
        button.layer.cornerRadius = 32
        button.layer.shadowColor = UIColor.accent.cgColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 1.0
        
        let image = UIImage(systemName: "plus")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(.buttonImageConfiguration, forImageIn: .normal)
        
        button.addTarget(self, action: #selector(addRecipeButtonDidTap), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let needRecipesLabel: UILabel = {
        let label = UILabel()
        label.text = .localized("Need_add_recipes")
        label.textColor = .lightGray
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    let recipesReuseId = "RecipesCollectionViewCell"
    
    var searchButtonLeadingConstraint: NSLayoutConstraint!
    var searchButtonTrailingConstraint: NSLayoutConstraint!
    
    var searchIsOpen: Bool = false
    
    var recipeList: [Recipe] = []
    var fullRecipeList: [Recipe] = []
    
    var addRecipeButtonPositionOn: CGFloat!
    var addRecipeButtonPositionOff: CGFloat!
    
    var style: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    
    // MARK: - Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCollectionView()
        
        setupViews()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if addRecipeButtonPositionOn == nil {
            addRecipeButtonPositionOn = addRecipeButton.frame.origin.y
            addRecipeButtonPositionOff = view.frame.height + 10
        }
        
    }
}

// MARK: - Setup Views
extension RecipesViewController {
    
    func addSearchField() {
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        view.addSubview(searchTextField)
        searchTextField.heightAnchor.constraint(equalToConstant: 24).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32 + 32 + 8).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(32 + 18 + 7)).isActive = true
        searchTextField.centerYAnchor.constraint(equalTo: recipesLabel.centerYAnchor).isActive = true
        
        view.addSubview(closeSearchButton)
        closeSearchButton.heightAnchor.constraint(equalToConstant: 18).isActive = true
        closeSearchButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        closeSearchButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor).isActive = true
        closeSearchButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -(32 + 16)).isActive = true
    }
    
    func removeTextField() {
        searchTextField.removeFromSuperview()
        closeSearchButton.removeFromSuperview()
    }
    
    func addNeedRecipesLabel() {
        
        view.addSubview(needRecipesLabel)
        needRecipesLabel.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16 + 24).isActive = true
        needRecipesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        needRecipesLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 32).isActive = true
    }
    
    func setupViews() {
        style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = .background
        
        view.addSubview(recipesLabel)
        
        
        view.addSubview(searchButton)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(.init(nibName: recipesReuseId, bundle: nil), forCellWithReuseIdentifier: recipesReuseId)
        view.addSubview(collectionView)
        
        view.addSubview(addRecipeButton)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        recipesLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant:
            32).isActive = true
        recipesLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        
        searchButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: recipesLabel.centerYAnchor).isActive = true
        searchButtonLeadingConstraint = searchButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32)
        searchButtonTrailingConstraint = searchButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32)
        searchButtonTrailingConstraint.isActive = true
        
        collectionView.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 16.0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        addRecipeButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        addRecipeButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        addRecipeButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -12).isActive = true
        addRecipeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12).isActive = true
    }
}

// MARK: - Actions
extension RecipesViewController {
    
    @objc func searchButtonDidTap() {
        animateSearchField(to: true)
    }
    
    @objc func closeSearchButtonDidTap() {
        if searchTextField.text!.isEmpty {
            searchTextField.resignFirstResponder()
            animateSearchField(to: false)
        } else {
            searchTextField.text = nil
            searchTextField.becomeFirstResponder()

            recipeList = fullRecipeList
            needRecipesLabel.text = .localized("Need_add_recipes")

            if recipeList.count == 0 {
                addNeedRecipesLabel()
            } else {
                needRecipesLabel.removeFromSuperview()
            }

            collectionView.reloadData()
        }
    }
    
    @objc func addRecipeButtonDidTap() {
        let destinationVC = AddRecipeViewController2()
        destinationVC.completionFunc = updateCollectionView
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    func updateCollectionView() {
        recipeList = RecipesScreenDataManager.instance.getRecipeList(withSortKey: "name")
        
        if recipeList.count == 0 { addNeedRecipesLabel() }
        else { needRecipesLabel.removeFromSuperview() }
        
        fullRecipeList = recipeList
        collectionView.reloadData()
    }
}

// MARK: - Animations
extension RecipesViewController {
    func showSearchField(to state: Bool) {
        if state { addSearchField() }
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.curveEaseOut],
            animations: {
                self.searchTextField.alpha = state ? 1.0 : 0.0
                self.closeSearchButton.alpha = state ? 1.0 : 0.0
            },
            completion: {_ in
                if !state {
                    self.removeTextField()
                    self.moveSearchButton(to: state)
                }
                self.searchIsOpen = state
            }
        )
    }
    
    func moveSearchButton(to state: Bool) {
        if state {
            searchButtonTrailingConstraint.isActive = false
            searchButtonLeadingConstraint.isActive = true
        } else {
            searchButtonLeadingConstraint.isActive = false
            searchButtonTrailingConstraint.isActive = true
        }
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1.0,
            options: [.curveEaseOut],
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if state { self.showSearchField(to: state) }
                else { self.showRecipesLabel(to: state) }
            }
        )
    }
    
    func showRecipesLabel(to state: Bool) {
        UIView.animate(
            withDuration: 0.1,
            animations: {
            self.recipesLabel.alpha = state ? 0.0 : 1.0
            },
            completion: { _ in
                if state { self.moveSearchButton(to: state) }
            }
        )
    }
    
    func animateSearchField(to state: Bool) {
        if state { showRecipesLabel(to: state) }
        else { showSearchField(to: state) }
    }
    
    func animateAddRecipeButton(to state: Bool) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 1.0,
            options: [.curveEaseOut],
            animations: {
                self.addRecipeButton.frame.origin.y = state ? self.addRecipeButtonPositionOn
                                                            : self.addRecipeButtonPositionOff
            },
            completion: nil
        )
    }
}

// MARK: - Collection View Data Source
extension RecipesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        recipeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recipesReuseId, for: indexPath) as! RecipesCollectionViewCell
        let recipe = recipeList[indexPath.row]
        let category = recipe.category
        
        var image: UIImage!
        var recipeCategory: String!
        switch category {
        case 0:
            image = UIImage(named: "breakfast.jpg")!
            recipeCategory = .localized("Breakfast")
        case 1:
            image = UIImage(named: "dinner.jpg")
            recipeCategory = .localized("Dinner")
        case 2:
            image = UIImage(named: "dinner2.jpg")
            recipeCategory = .localized("Dinner2")
        default: break
        }
        
        cell.delegate = self
        cell.index = indexPath.row
        cell.imageView.image = image
        cell.recipeNameLabel.text = recipe.name
        cell.recipeCategory.text = recipeCategory
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension RecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationVC = RecipePageViewController()
        destinationVC.recipe = recipeList[indexPath.row]
        
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    func deleteCell(at index: Int) {
        RecipesScreenDataManager.instance.deleteRecipe(at: index, withSortKey: "name")
        updateCollectionView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if addRecipeButtonPositionOn != nil {
            if recipeList.count != 0 {
                if collectionView.indexPathsForVisibleItems.contains(IndexPath(row: 0, section: 0)) {
                    animateAddRecipeButton(to: true)
                } else {
                    animateAddRecipeButton(to: false)
                }
            }
        }
    }
}

// MARK: - Collection View Delegate Flow Layout
extension RecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.collectionView.frame.size.width
        let height = CGFloat.init(112.0)
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - Collection View Cell Delegate
extension RecipesViewController: RecipesCollectionViewCellDelegate {
    func moreButtonDidTap(_ collectionViewCell: RecipesCollectionViewCell) {
        let alert = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: .localized("Cancel"), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: .localized("Edit"), style: .default, handler: { action in
            let destinationVC = AddRecipeViewController2()
            destinationVC.completionFunc = self.updateCollectionView
            destinationVC.type = .edit
            destinationVC.recipeIndex = collectionViewCell.index

            let recipe = self.recipeList[collectionViewCell.index]
            destinationVC.recipeName = recipe.name
            destinationVC.category = Int(recipe.category)

            do {
                try destinationVC.ingredients = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(recipe.ingredients!) as! [String]
                try destinationVC.steps = NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(recipe.steps!) as! [String]
            } catch {}

            destinationVC.ingredients.append(.localized("Add_ingredient"))
            destinationVC.steps.append(.localized("Add_step"))

            self.present(destinationVC, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: .localized("Delete"), style: .destructive, handler: { action in
            self.deleteCell(at: collectionViewCell.index)

            let cell = collectionViewCell
            TodayScreenDataManager.WeekdayKeys.forEach({ key in
                let dishes = UserDefaults.standard.array(forKey: key) as! [String]
                dishes.forEach({ dish in
                    if dish == cell.recipeNameLabel.text {
                        TodayScreenDataManager.instance.changeDish(on: .localized("Not_selected"), inCategory: dishes.firstIndex(of: dish)!, forKey: key)
                    }
                })
            })

            NotificationCenter.default.post(name: .reloadCardsPagerView, object: nil)
        }))

        alert.view.tintColor = .primary
        self.present(alert, animated: true)
    }
}

// MARK: - Text Filed Delegate
extension RecipesViewController: UITextFieldDelegate {

    @objc func textFieldDidChange(_ textField: UITextField) {
        recipeList.removeAll()
        
        if textField.text!.isEmpty { recipeList = fullRecipeList }
        else {
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
                addNeedRecipesLabel()
                needRecipesLabel.text = .localized("Recipes_not_found")
            } else {
                needRecipesLabel.removeFromSuperview()
            }
        } else {
            needRecipesLabel.text = .localized("Need_add_recipes")
            if recipeList.count != 0 { needRecipesLabel.removeFromSuperview() }
        }

        collectionView.reloadData()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()

        return true
    }

}

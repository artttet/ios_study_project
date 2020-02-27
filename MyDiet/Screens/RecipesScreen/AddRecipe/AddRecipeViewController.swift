import UIKit

class AddRecipeViewController2: UIViewController {
    
    enum AddType {
        case add, edit
    }
    
    // MARK: -  Views
    var addRecipeLabel: UILabel = {
        let label = UILabel()
        label.text = .localized("Add_recipe")
        label.textColor = .primary
        label.font = .preferredFont(forTextStyle: .headline)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var closeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
        button.setTitle(.localized("Close"), for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .background
        tableView.sectionFooterHeight = 4.0
        tableView.sectionHeaderHeight = 48.0
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    let readyButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(.localized("Ready"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .primary
        
        button.layer.cornerRadius = 23
        button.layer.shadowColor = UIColor.primary.cgColor
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        button.layer.shadowRadius = 6
        
        button.addTarget(self, action: #selector(mainReadyButtonAction), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var pickerStackView: PickerStackView = {
        let stackView = PickerStackView()
        stackView.state = false
        stackView.isHidden = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        view.isHidden = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    // MARK: - Properties
    let nameReuseId = "Name"
    let ingredientReuseId = "Ingredient"
    let stepReuseId = "Step"
    
    let categories: [String] = [.localized("Category"),.localized("Breakfast"), .localized("Dinner"), .localized("Dinner2")]
    
    var currentTextField: UITextField!
    var currentTextView: UITextView!
    
    var type: AddType!
    var recipeName: String!
    var category: Int = -1
    var ingredients: [String] = [.localized("Add_ingredient")]
    var steps: [String] = [.localized("Add_step")]
    
    var completionFunc: (() -> Void)!
    
    // MARK: - Edit Properties
    var oldRecipeName: String!
    var recipeIndex: Int!

    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        setupViews()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if pickerStackView.frame.origin.y != pickerStackView.yPositionOn {
            pickerStackView.frame.origin.y = pickerStackView.yPositionOff
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if pickerStackView.yPositionOff == nil {
            pickerStackView.yPositionOff = view.frame.height
            pickerStackView.yPositionOn = view.frame.height - pickerStackView.frame.height
        }
    }
    
    // MARK: - Public Functions
    
    func deleteRow(at indexPath: IndexPath) {
        var str: String
        
        if indexPath.section == 1 {
            str = "Delete_ingredient"
        } else {
            str = "Delete_step"
        }
        let alert = UIAlertController(title: "\(String.localized(str))?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: .localized("Yes"), style: .default, handler: { action in
            self.tableView.beginUpdates()
            
            if indexPath.section == 1 {
                self.ingredients.remove(at: indexPath.row)
            } else {
                self.steps.remove(at: indexPath.row)
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.tableView.endUpdates()
        }))
        
        alert.addAction(UIAlertAction(title: .localized("No"), style: .cancel, handler: nil))
        
        alert.view.tintColor = .primary

        self.present(alert, animated: true)
    }

}

// MARK: - Setup Views

extension AddRecipeViewController2 {
    func setupViews() {
        view.addSubview(addRecipeLabel)
        
        view.addSubview(closeButton)
        
        view.addSubview(separator)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AddRecipeTableViewCell2.self, forCellReuseIdentifier: nameReuseId)
        tableView.register(AddRecipeTableViewCell2.self, forCellReuseIdentifier: ingredientReuseId)
        tableView.register(AddRecipeTableViewCell2.self, forCellReuseIdentifier: stepReuseId)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + 46 + 24, right: 0)
        view.addSubview(tableView)
        
        view.addSubview(readyButton)
        
        view.addSubview(backgroundView)
        
        pickerStackView.delegate = self
        pickerStackView.titles = categories
        view.addSubview(pickerStackView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        addRecipeLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8).isActive = true
        addRecipeLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        
        closeButton.centerYAnchor.constraint(equalTo: addRecipeLabel.centerYAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12.0).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separator.topAnchor.constraint(equalTo: addRecipeLabel.bottomAnchor, constant: 8).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        readyButton.heightAnchor.constraint(equalToConstant: 46).isActive = true
        readyButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        readyButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        readyButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -16).isActive = true

        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        pickerStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35).isActive = true
        pickerStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        pickerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
}

// MARK: - Actions

extension AddRecipeViewController2 {
    @objc func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func mainReadyButtonAction() {
        let alert = UIAlertController(title: "\(String.localized("Error"))!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: .localized("Ok"), style: .default, handler: { action in
            return
        }))
        alert.view.tintColor = .primary
        
        if recipeName == nil {
            alert.message = .localized("Need_enter_recipe_name")
            
            self.present(alert, animated: true)
        } else if category == -1 {
            alert.message = .localized("Need_choose_category")
            
            self.present(alert, animated: true)
        } else {
            var finishIngredients: [String] = []
            ingredients.forEach({ (ingredient) in
                if ingredient != "" && ingredient != .localized("Add_ingredient") {
                    finishIngredients.append(ingredient)
                }
            })
            
            var finishSteps: [String] = []
            steps.forEach({ (step) in
                if step != "" && step != .localized("Add_step") {
                    finishSteps.append(step)
                }
            })
            
            var ingredientsData: Data!
            var stepsData: Data!
            
            do {
                try ingredientsData = NSKeyedArchiver.archivedData(withRootObject: finishIngredients, requiringSecureCoding: false)
                try stepsData = NSKeyedArchiver.archivedData(withRootObject: finishSteps, requiringSecureCoding: false)
            } catch {}
            
            if type == .add {
                let recipeList = RecipesScreenDataManager.instance.getRecipeList(withSortKey: "name")
                var counter = 0
                var tmpRecipeName: String!
                recipeList.forEach( { recipe in
                    if let name = recipe.name {
                        if recipeName == name {
                            counter += 1
                            tmpRecipeName = recipeName + " (\(counter))"
                        }
                        
                        if name.contains(recipeName + " (") {
                            counter += 1
                            tmpRecipeName = recipeName + " (\(counter))"
                        }
                    }
                })
                if let name = tmpRecipeName {
                    recipeName = name
                }
            }
            
            if type == .edit {
                RecipesScreenDataManager.instance.deleteRecipe(at: recipeIndex, withSortKey: "name")
                
                TodayScreenDataManager.WeekdayKeys.forEach({ key in
                    let dishes = UserDefaults.standard.array(forKey: key) as! [String]
                    dishes.forEach({ dish in
                        if dish == oldRecipeName {
                            TodayScreenDataManager.instance.changeDish(on: recipeName, inCategory: dishes.firstIndex(of: dish)!, forKey: key)
                        }
                    })
                })
                
                NotificationCenter.default.post(name: .reloadCardsPagerView, object: nil)
            }
    
            let recipe = Recipe()
            
            recipe.name = recipeName
            recipe.category = Int32(category)
            recipe.ingredients = ingredientsData
            recipe.steps = stepsData
            
            CoreDataManager.instance.saveContext(forEntity: .Recipe)
            completionFunc()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func animatePickerStackView() {
        let state = pickerStackView.state!
        if !state {
            pickerStackView.isHidden = false
            backgroundView.isHidden = false
        }
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0.0,
            options: [(state ? .curveEaseIn : .curveEaseOut), .transitionCrossDissolve],
            animations: {
                if state {
                    self.pickerStackView.frame.origin.y = self.pickerStackView.yPositionOff
                    self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                } else {
                    self.pickerStackView.frame.origin.y = self.pickerStackView.yPositionOn
                    self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                }
            },
            completion: { _ in
                if state {
                    self.pickerStackView.isHidden = true
                    self.backgroundView.isHidden = true
                }
                self.pickerStackView.state = !state
            }
        )
    }
}

// MARK: - Keyboard Functions
fileprivate var keyboardHeight: CGFloat!
extension AddRecipeViewController2 {
    
    
    @objc func keyboardWillShow(notification: Notification) {
        
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.tableView.contentInset.bottom += keyboardHeight
            })
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.tableView.contentInset.bottom -= keyboardHeight
        })
        keyboardHeight = nil
    }
}

// MARK: - UITableViewDataSource
extension AddRecipeViewController2: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number: Int!
        
        switch section {
        case 0: number = 2
        case 1: number = ingredients.count
        case 2: number = steps.count
        default: break
        }
        
        return number
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var name: String!
        
        switch section {
        case 0: name = ""
        case 1: name = .localized("Ingredients")
        case 2: name = .localized("Cooking")
        default: break
        }
        
        return name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let index = indexPath.row
        
        // General
        if section == 0 {
            if index == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: nameReuseId, for: indexPath) as! AddRecipeTableViewCell2
                cell.type = .name
                cell.placeholder = .localized("Name_of_recipe")
                cell.indexPath = indexPath
                cell.delegate = self
                
                if let name = recipeName {
                    cell.textField.text = name
                }
                
                cell.setupView()
                
                return cell
            } else {
                let cell = UITableViewCell()
                
                cell.textLabel?.text = categories[category + 1]
                cell.textLabel?.textColor = category == -1 ? .placeholderText : .primaryPlus
                
                return cell
            }
        }
        
        // Ingredients
        if section == 1 {
            if index == ingredients.count - 1{
                let cell = UITableViewCell()
                
                cell.textLabel?.text = .localized("Add_ingredient")
                cell.textLabel?.textColor = .primary
                
                let imageView = UIImageView(image: UIImage(systemName: "plus"))
                imageView.tintColor = .primary
                cell.accessoryView = imageView
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: ingredientReuseId, for: indexPath) as! AddRecipeTableViewCell2
                cell.type = .ingredient
                cell.placeholder = ingredients[index] == "" ? .localized("Enter_ingredient") : ingredients[index]
                cell.indexPath = indexPath
                cell.delegate = self
                
                cell.setupView()
                
                cell.textField.textColor = ingredients[index] == "" ? .placeholderText : .primaryPlus
                
                return cell
            }
        }
        
        // Cooking
        if section == 2 {
            if index == steps.count - 1 {
                let cell = UITableViewCell()
                
                cell.textLabel?.text = .localized("Add_step")
                cell.textLabel?.textColor = .primary
                
                let imageView = UIImageView(image: UIImage(systemName: "plus"))
                imageView.tintColor = .primary
                cell.accessoryView = imageView
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: stepReuseId, for: indexPath) as! AddRecipeTableViewCell2
                cell.type = .step
                cell.placeholder = steps[index] == "" ? .localized("Enter_step") : steps[index]
                cell.indexPath = indexPath
                cell.delegate = self
                
                cell.setupView()
                
                cell.textView.textColor = steps[index] == "" ? .placeholderText : .primaryPlus
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
}

// MARK: - UItableViewDelegate
extension AddRecipeViewController2: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let index = indexPath.row
        
        
        // General
        if section == 0 {
            if index == 0 {
                let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell2
                cell.textField.becomeFirstResponder()
            } else {
                if currentTextField != nil {
                    if currentTextField.isFirstResponder {
                        currentTextField.resignFirstResponder()
                    }
                }
                if currentTextView != nil {
                    if currentTextView.isFirstResponder {
                        currentTextView.resignFirstResponder()
                    }
                }
    
                pickerStackView.updateTitles(to: nil, with: category + 1)
                animatePickerStackView()
            }
        }
        
        // Ingredients
        if section == 1 {
            if index == ingredients.count - 1 {
                tableView.beginUpdates()
                ingredients.insert("", at: ingredients.count == 1 ? 0 : ingredients.count - 1)
                tableView.insertRows(at: [IndexPath(row: ingredients.count - 2, section: 1)], with: .automatic)
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.endUpdates()
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell2
                cell.textField.becomeFirstResponder()
            }
        }
        
        // Steps
        if section == 2 {
            if index == steps.count - 1 {
                tableView.beginUpdates()
                steps.insert("", at: steps.count == 1 ? 0 : steps.count - 1)
                tableView.insertRows(at: [IndexPath(row: steps.count - 2, section: 2)], with: .automatic)
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.endUpdates()
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell2
                cell.textView.becomeFirstResponder()
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Add Recipe Table View Cell Delegate
extension AddRecipeViewController2: AddRecipeTableViewCellDelegate {
    func checkButtonDidTap(indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell2
        
        if indexPath.section == 1 {
            if cell.textField.isFirstResponder {
                cell.textField.resignFirstResponder()
            }
        } else if indexPath.section == 2 {
            if cell.textView.isFirstResponder {
                cell.textView.resignFirstResponder()
            }
        }
    }
    
    func minusButtonDidTap(indexPath: IndexPath) {
        deleteRow(at: indexPath)
    }
    
    func changeRecipeData(newValue: String, indexPath: IndexPath) {
        if indexPath.section == 0 {
            recipeName = newValue
        }

        if indexPath.section == 1 {
            ingredients[indexPath.row] = newValue
        }

        if indexPath.section == 2 {
            steps[indexPath.row] = newValue
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField, indexPath: IndexPath) {
        currentTextField = textField
        if indexPath.section != 0 {
            let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell2
            cell.accessoryView = cell.checkAccessoryView
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, indexPath: IndexPath) {
        let text = textField.text
        
        if indexPath.section != 0 {
            let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell2
            cell.accessoryView = cell.minusAccessoryView
        }
        
        if let finalText = text {
            changeRecipeData(newValue: finalText, indexPath: indexPath)
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView, indexPath: IndexPath) {
        currentTextView = textView
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = .primaryPlus
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell2
        cell.accessoryView = cell.checkAccessoryView
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView, indexPath: IndexPath) {
        let text = textView.text
        
        if text!.isEmpty {
            textView.text = .localized("Enter_step")
            textView.textColor = .placeholderText
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell2
        cell.accessoryView = cell.minusAccessoryView
        
        if let finalText = text {
            changeRecipeData(newValue: finalText, indexPath: indexPath)
        }
    }
    
    func textViewDidChange() {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: true)
    }
    
    
}

// MARK: - PickerStackViewDelegate
extension AddRecipeViewController2: PickerStackViewDelegate {
    func cancelButtonDidTap() {
        animatePickerStackView()
    }
    
    func readyButtonDidTap() {
        category = pickerStackView.selectedRow() - 1
        tableView.reloadData()
        animatePickerStackView()
    }
}

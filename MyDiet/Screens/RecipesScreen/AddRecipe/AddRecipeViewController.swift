import UIKit
import MobileCoreServices

extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"),
            self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}

class AddRecipeViewController: UIViewController, UITextViewDelegate {
    @IBOutlet var readyButtonView: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var topViewInStack: UIView!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet var backgroundView: UIView!
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func readyButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "Ошибка!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
            return
        }))
        alert.view.tintColor = UIColor(named: "primaryColor")
        
        if recipeName == nil || recipeName == "Название рецепта" {
            alert.message = "Необходимо ввести название рецепта"
            
            self.present(alert, animated: true)
        } else if category == "Категория" {
            alert.message = "Необходимо выбрать категорию"
            
            self.present(alert, animated: true)
        } else {
            var finishIngredients: [String] = []
            ingredients.forEach({ (ingredient) in
                if ingredient != "Введите ингредиент" && ingredient != "Добавить ингредиент" {
                    finishIngredients.append(ingredient)
                }
            })
            
            var finishSteps: [String] = []
            steps.forEach({ (step) in
                if step != "Введите шаг" && step != "Добавить шаг" {
                    finishSteps.append(step)
                }
            })
            
            let recipe = Recipe()
            
            recipe.name = recipeName
            recipe.category = category
            
            do {
                try recipe.ingredients = NSKeyedArchiver.archivedData(withRootObject: finishIngredients, requiringSecureCoding: false)
                try recipe.steps = NSKeyedArchiver.archivedData(withRootObject: finishSteps, requiringSecureCoding: false)
            } catch {}
            
            CoreDataManager.instance.saveContext(forEntity: Entity.Recipe)
            NotificationCenter.default.post(name: .init(Notifications.UpdateRecipesCollectionView.rawValue), object: nil)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    @IBAction func stackCancelAction(_ sender: Any) {
        closeCategory()
        
        category = "Категория"
        
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    @IBAction func stackReadyAction(_ sender: Any) {
        closeCategory()
        
        category = pickerViewTitles[pickerView.selectedRow(inComponent: 0)]
        
        tableView.beginUpdates()
        tableView.reloadData()
        tableView.endUpdates()
    }
    
    let reuseId = "AddRecipeTableViewCell"
    
    let pickerViewTitles = ["Завтрак", "Обед", "Ужин"]
    
    var recipeName: String!
    
    var category: String!
    
    var isOpenCategory: Bool = false
    
    var ingredients = ["Введите ингредиент", "Добавить ингредиент"]
    
    var steps = ["Введите шаг", "Добавить шаг"]
    
    var lastActiveTextIndexPath: IndexPath!
    
    var keyboardHeight: CGFloat!
    
    var closedStackViewYPosition: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        recipeName = "Название рецепта"
        
        category = "Категория"
        
        readyButtonView.layer.cornerRadius = readyButtonView.frame.size.height / 2
        
        readyButtonView.layer.shadowColor = UIColor(named: "primaryColor")?.cgColor
        readyButtonView.layer.shadowOpacity = 0.7
        readyButtonView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        readyButtonView.layer.shadowRadius = 6
        
        topViewInStack.layer.cornerRadius = 12
        topViewInStack.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
        tableView.register(UINib(nibName: reuseId, bundle: nil), forCellReuseIdentifier: reuseId)
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeItem(_:)), name: .init(Notifications.ChangeText.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .init(Notifications.UpdateTableView.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(lastActiveTextIndexPath(_:)), name: .init(Notifications.LastActiveTextIndexPath.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isOpenCategory {
            stackView.frame.origin.y += stackView.frame.size.height
        }
    }
    
    @objc
    func updateTableView() {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: true)
    }
    
    @objc
    func lastActiveTextIndexPath(_ notification: Notification) {
        let object = notification.object as! [String : Any]
        self.lastActiveTextIndexPath = object["indexPath"] as? IndexPath
    }
    
    @objc
    func changeItem(_ notification: Notification) {
        let object = notification.object as! [String : Any]
        let indexPath = object["indexPath"] as! IndexPath
        let item = object["item"] as? String
        
        if indexPath.section == 0 {
            recipeName = item
        }
        
        if indexPath.section == 1 {
            ingredients[indexPath.row] = item!
        }
        
        if indexPath.section == 2 {
            steps[indexPath.row] = item!
        }
    }
    
    func openCategory() {
        isOpenCategory = true
        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        self.backgroundView.isHidden = false
        self.stackView.isHidden = false
        
        if let position = closedStackViewYPosition {
            self.stackView.frame.origin.y = position
        }
        
        if UIApplication.shared.isKeyboardPresented {
            if let cell = tableView.cellForRow(at: lastActiveTextIndexPath) as? AddRecipeTableViewCell {
                cell.textField.resignFirstResponder()
            }
            
            if let cell = tableView.cellForRow(at: lastActiveTextIndexPath) as? TextTableViewCell {
                cell.textView.resignFirstResponder()
            }
        }
    
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: [.curveEaseIn],
            animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
                
                self.stackView.frame.origin.y -= self.stackView.frame.size.height
        })
    }
    
    func closeCategory() {
        isOpenCategory = false
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: [.curveEaseOut],
            animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                
                self.stackView.frame.origin.y += self.stackView.frame.size.height
        }, completion: {_ in
            self.backgroundView.isHidden = true
            self.stackView.isHidden = true
            
            self.closedStackViewYPosition = self.stackView.frame.origin.y
        })
    }
    
    func deleteRow(at indexPath: IndexPath) {
        var item: String
        
        if indexPath.section == 1 {
            item = "ингредиент"
        } else {
            item = "шаг"
        }
        let alert = UIAlertController(title: "Удалить \(item)?", message: "Вы действительно хотите удалить \(item)?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            self.tableView.beginUpdates()
            
            if indexPath.section == 1 {
                self.ingredients.remove(at: indexPath.row)
            } else {
                self.steps.remove(at: indexPath.row)
            }
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.tableView.endUpdates()
        }))
        
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        
        alert.view.tintColor = UIColor(named: "primaryColor")

        self.present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AddRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return ""
        case 1:
            return "Ингредиенты"
        case 2:
            return "Приготовление"
        default:
            break
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return ingredients.count
        case 2:
            return steps.count
        default:
            break
        }
        return -1
    }
    
    // MARK: - CellForRowAt
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
            
        // Genearal Section
        case 0:
            switch indexPath.row {
                
            // Recipe Name
            case 0:
                let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseId) as! AddRecipeTableViewCell
                cell.backgroundColor = UIColor.white
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                cell.indexPath = indexPath
                
                if recipeName == "Название рецепта" {
                    cell.textField.attributedPlaceholder = NSAttributedString(string: recipeName, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
                } else {
                    cell.textField.text = recipeName
                    cell.textField.textColor = UIColor(named: "primaryPlusColor")
                }
                
                cell.accessoryView = nil
                
                return cell
                
            // Category Name
            case 1:
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.backgroundColor = UIColor.white
                cell.selectionStyle = UITableViewCell.SelectionStyle.gray
                
                cell.textLabel?.text = category
                if category == "Категория" {
                    cell.textLabel?.textColor = UIColor.lightGray
                } else {
                    cell.textLabel?.textColor = UIColor(named: "primaryPlusColor")
                }
                
                return cell
            default: break }
            
        // Ingredients Section
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseId) as! AddRecipeTableViewCell
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            cell.textField.textColor = UIColor(named: "primaryPlusColor")
            
            if ingredients[indexPath.row] != "Введите ингредиент" {
                cell.textField.text = ingredients[indexPath.row]
                
            } else {
                cell.textField.text = nil
                cell.textField.attributedPlaceholder = NSAttributedString(string: ingredients[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            }
            
            // Add Ingredient
            if indexPath.row == ingredients.count - 1 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
                cell.backgroundColor = UIColor.white
                cell.selectionStyle = UITableViewCell.SelectionStyle.gray;
                
                let imageView = UIImageView(image: UIImage(systemName: "plus"))
                imageView.tintColor = UIColor(named: "primaryColor")
                cell.accessoryView = imageView
                
                cell.textLabel?.text = ingredients[indexPath.row]
                cell.textLabel?.textColor = UIColor(named: "primaryColor")
                
                return cell
                
            // Ingredient
            } else {
                cell.indexPath = indexPath
                
                let imageView = UIImageView(image: UIImage(systemName: "minus.circle.fill"))
                imageView.tintColor = UIColor(named: "primaryColor")
                cell.accessoryView = imageView
            }
            
            return cell
        // Cooking Section
        case 2:
            
            // Add Step
            if indexPath.row == steps.count-1 {
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                cell.backgroundColor = UIColor.white
                cell.selectionStyle = UITableViewCell.SelectionStyle.gray;
                
                cell.textLabel?.text = steps[indexPath.row]
                cell.textLabel?.textColor = UIColor(named: "primaryColor")
                
                let imageView = UIImageView(image: UIImage(systemName: "plus"))
                imageView.tintColor = UIColor(named: "primaryColor")
                cell.accessoryView = imageView
                
                return cell
                
            // Step
            } else {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell") as! TextTableViewCell
                cell.backgroundColor = UIColor.white
                cell.selectionStyle = UITableViewCell.SelectionStyle.none;
                cell.indexPath = indexPath
                
                cell.contentView.removeFromSuperview()
                
                cell.textView.text = steps[indexPath.row]
                if cell.textView.text != "Введите шаг" {
                    cell.textView.textColor = UIColor(named: "primaryPlusColor")
                } else {
                    cell.textView.textColor = UIColor.lightGray
                }
                
                let imageView = UIImageView(image: UIImage(systemName: "minus.circle.fill"))
                imageView.tintColor = UIColor(named: "primaryColor")
                cell.accessoryView = imageView
                
                return cell
            }
        default: break }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension AddRecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        // General section
        case 0:
            
            // Recipe Name
            if indexPath.row == 0 {
                let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell
                
                cell.textField.becomeFirstResponder()
            }
            
            // Category Name
            if indexPath.row == 1 {
                openCategory()
            }
            
            // Ingredinents section
        case 1:
            
            // Add Ingredient
            if indexPath.row == ingredients.count - 1 {
                tableView.beginUpdates()
                ingredients.insert("Введите ингредиент", at: ingredients.count == 1 ? 0 : ingredients.count - 1)
                tableView.insertRows(at: [IndexPath(row: ingredients.count-2, section: 1)], with: .automatic)
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.endUpdates()
            // Ingredient
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell
                
                if cell.textField.isFirstResponder {
                    cell.textField.resignFirstResponder()
                    
                } else {
                    deleteRow(at: indexPath)
                }
            }
            
        // Cooking section
        case 2:
            if indexPath.row == steps.count - 1 {
                tableView.beginUpdates()
                steps.insert("Введите шаг", at: steps.count == 1 ? 0 : steps.count - 1)
                tableView.insertRows(at: [IndexPath(row: steps.count - 2, section: 2)], with: .automatic)
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.endUpdates()
            } else {
                let cell = tableView.cellForRow(at: indexPath) as! TextTableViewCell
                
                if cell.textView.isFirstResponder {
                    cell.textView.resignFirstResponder()
                } else {
                    deleteRow(at: indexPath)
                }
            }
        default: break }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 2 {
            if indexPath.row != steps.count - 1 {
                return false
            }
        }
        
        return true
    }
}

// MARK: - KeyboardFunctions
extension AddRecipeViewController {
    @objc
    func keyboardWillShow(notification: Notification) {
        
        if keyboardHeight != nil {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
                self.tableView.contentInset.bottom += self.keyboardHeight
            })
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseIn, animations: {
            self.tableView.contentInset.bottom -= self.keyboardHeight
        })
        self.keyboardHeight = nil
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension AddRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerViewTitles[row]
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "primaryColor")!])
        
        return attributedTitle
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewTitles[row]
    }
}

// MARK: - AddRecipeTableViewCell
class AddRecipeTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.backgroundColor = UIColor.white
        
        self.textField.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if indexPath.section != 0 {
            let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
            imageView.tintColor = UIColor(named: "primaryColor")
            accessoryView = imageView
        }
        
        let object = ["indexPath" : indexPath]
        NotificationCenter.default.post(name: .init(Notifications.LastActiveTextIndexPath.rawValue), object: object)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var text = textField.text
        
        if textField.text!.isEmpty {
            if indexPath.section == 0 {
                text = nil
            } else {
                text = "Введите ингредиент"
            }
        }
        
        if indexPath.section != 0 {
            let imageView = UIImageView(image: UIImage(systemName: "minus.circle.fill"))
            imageView.tintColor = UIColor(named: "primaryColor")
            accessoryView = imageView
        }
        
        if let finalText = text {
            let object = ["indexPath" : self.indexPath!, "item" : text] as [String : Any]
            NotificationCenter.default.post(name: .init(Notifications.ChangeText.rawValue), object: object)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        
        return true
    }
}

// MARK: - TextTableViewCell
class TextTableViewCell: UITableViewCell, UITextViewDelegate {
    @IBOutlet var textView: UITextView!

    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.isScrollEnabled = false
        textView.delegate = self
        
        textView.backgroundColor = UIColor.white
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(named: "primaryPlusColor")
        }
        
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = UIColor(named: "primaryColor")
        accessoryView = imageView
    
        let object = ["indexPath" : indexPath]
        NotificationCenter.default.post(name: .init(Notifications.LastActiveTextIndexPath.rawValue), object: object)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        var text = textView.text
        
        if textView.text.isEmpty {
            text = "Введите шаг"
            textView.text = text
            textView.textColor = UIColor.lightGray
        }
        
        let imageView = UIImageView(image: UIImage(systemName: "minus.circle.fill"))
        imageView.tintColor = UIColor(named: "primaryColor")
        accessoryView = imageView
        
        let object = ["indexPath" : self.indexPath!, "item" : text!] as [String : Any]
        NotificationCenter.default.post(name: .init(Notifications.ChangeText.rawValue), object: object)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let newHeight = self.frame.size.height + textView.contentSize.height
        self.frame.size.height = newHeight
        
        NotificationCenter.default.post(name: .init(Notifications.UpdateTableView.rawValue), object: nil)
    }
}

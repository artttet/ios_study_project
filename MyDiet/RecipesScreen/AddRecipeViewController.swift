//
//  AddRecipeViewController.swift
//  MyDiet
//
//  Created by Artas on 29/01/2020.
//  Copyright © 2020 Артем Чиглинцев. All rights reserved.
//

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
    @IBOutlet var backgroundView: UIView!
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func readyButtonAction(_ sender: Any) {
        var alert = UIAlertController(title: "Ошибка!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: { action in
            return
        }))
        alert.view.tintColor = UIColor(named: "primaryColor")
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AddRecipeTableViewCell
        let cell2 = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        
        if cell.textField.text!.isEmpty {
            alert.message = "Необходимо ввести название рецепта"
            
            self.present(alert, animated: true)
        } else if !pickerViewTitles.contains(cell2!.textLabel!.text!) {
            alert.message = "Необходимо выбрать категорию"
            
            self.present(alert, animated: true)
        }
        
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
        
        if let recipe = recipeName {
            if let category = category {
                print("Recipe Name - \(recipe)")
                print("Category - \(category)")
                print("Ingredients - \(finishIngredients)")
                print("Steps - \(finishSteps)")
                print("-----------------------------------------")
            }
        }
        
    }
    
    @IBAction func stackCancelAction(_ sender: Any) {
        categoryIsClose()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))!
        
        cell.textLabel?.text = "Категория"
        cell.textLabel?.textColor = UIColor.lightGray
        
        category = nil
    }
    
    @IBAction func stackReadyAction(_ sender: Any) {
        categoryIsClose()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))!
        
        category = pickerViewTitles[pickerView.selectedRow(inComponent: 0)]
        
        cell.textLabel?.text = category
        cell.textLabel?.textColor = UIColor(named: "plusButtonColor")
    }
    
    let reuseId = "AddRecipeTableViewCell"
    
    let pickerViewTitles = ["Завтрак", "Обед", "Ужин"]
    
    var recipeName: String!
    
    var category: String!
    
    var ingredients = ["Введите ингредиент", "Добавить ингредиент"]
    
    var steps = ["Введите шаг", "Добавить шаг"]
    
    var lastActiveTextIndexPath: IndexPath!
    
    var keyboardHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeItem(_:)), name: .init("changeItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: .init("updateTableView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(lastActiveTextIndexPath(_:)), name: .init("lastActiveTextIndexPath"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stackView.frame.origin.y = stackView.frame.origin.y + stackView.frame.size.height
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
    
    func categoryIsOpen() {
        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        self.backgroundView.isHidden = false
        self.stackView.isHidden = false
        
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
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                
                self.stackView.frame.origin.y -= self.stackView.frame.size.height
        })
    }
    
    func categoryIsClose() {
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
                
                cell.textField.attributedPlaceholder = NSAttributedString(string: "Название рецепта", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
                
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
                    cell.textLabel?.textColor = UIColor(named: "plusButtonColor")
                }
                
                 
                return cell
            default: break }
            
        // Ingredients Section
        case 1:
            let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseId) as! AddRecipeTableViewCell
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = UITableViewCell.SelectionStyle.none;
            
            cell.textField.attributedPlaceholder = NSAttributedString(string: ingredients[indexPath.row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
            
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
                    cell.textView.textColor = UIColor(named: "plusButtonColor")
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
                categoryIsOpen()
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
                print("RunTime Ingredients - \(ingredients)")
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
            
            UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
                self.tableView.contentInset.bottom += self.keyboardHeight
            }, completion: {_ in
                
            })
        }
    }
    
    @objc
    func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.tableView.contentInset.bottom -= self.keyboardHeight
        }, completion: {_ in
            self.keyboardHeight = nil
        })
    }
}

extension AddRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewTitles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerViewTitles[row]
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "primaryColor")])
        
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
        NotificationCenter.default.post(name: .init("lastActiveTextIndexPath"), object: object)
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
        
        let object = ["indexPath" : self.indexPath!, "item" : text] as [String : Any]
        NotificationCenter.default.post(name: .init("changeItem"), object: object)
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
            textView.textColor = UIColor(named: "plusButtonColor")
        }
        
        let imageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imageView.tintColor = UIColor(named: "primaryColor")
        accessoryView = imageView
    
        let object = ["indexPath" : indexPath]
        NotificationCenter.default.post(name: .init("lastActiveTextIndexPath"), object: object)
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
        NotificationCenter.default.post(name: .init("changeItem"), object: object)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let newHeight = self.frame.size.height + textView.contentSize.height
        self.frame.size.height = newHeight
        
        NotificationCenter.default.post(name: .init("updateTableView"), object: nil)
    }
}

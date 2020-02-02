//
//  AddRecipeViewController.swift
//  MyDiet
//
//  Created by Artas on 29/01/2020.
//  Copyright © 2020 Артем Чиглинцев. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController {
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
        print("i'm ready button")
    }
    
    @IBAction func stackCancelAction(_ sender: Any) {
        categoryIsClose()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))!
        
        cell.textLabel?.text = "Категория"
        cell.textLabel?.textColor = UIColor.lightGray
    }
    
    @IBAction func stackReadyAction(_ sender: Any) {
        categoryIsClose()
        
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))!
        
        cell.textLabel?.text = pickerViewTitles[pickerView.selectedRow(inComponent: 0)]
        cell.textLabel?.textColor = UIColor(named: "primaryColor")
    }
    
    let reuseId = "AddRecipeTableViewCell"
    let pickerViewTitles = ["Завтрак", "Обед", "Ужин"]
    
    var numberOfIngridients = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()

        readyButtonView.layer.cornerRadius = readyButtonView.frame.size.height / 2
        
        readyButtonView.layer.shadowColor = UIColor(named: "primaryColor")?.cgColor
        readyButtonView.layer.shadowOpacity = 0.7
        readyButtonView.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        readyButtonView.layer.shadowRadius = 6
        
        topViewInStack.layer.cornerRadius = 12
        topViewInStack.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 48, right: 0)
        tableView.register(UINib(nibName: reuseId, bundle: nil), forCellReuseIdentifier: reuseId)
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        stackView.frame.origin.y = stackView.frame.origin.y + stackView.frame.size.height
    }
    
    func categoryIsOpen() {
        self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        
        self.backgroundView.isHidden = false
        self.stackView.isHidden = false
    
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: [.curveEaseIn],
            animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                
                self.stackView.frame.origin.y -= self.stackView.frame.size.height
        }, completion: {_ in
            
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

}

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
            return numberOfIngridients
        case 2:
            return 2
        default:
            break
        }
        return -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseId) as! AddRecipeTableViewCell
                
                cell.textField.attributedPlaceholder = NSAttributedString(string: "Название рецепта", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
                
                return cell
            }
            if indexPath.row == 1{
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                
                cell.textLabel?.text = "Категория"
                cell.textLabel?.textColor = UIColor.lightGray
                
                return cell
            }
        case 1:
            if indexPath.row == 1 {
            
            }
        default:
            break
        }

        return cell
    }
    
    
}

extension AddRecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.cellForRow(at: indexPath) as! AddRecipeTableViewCell
                
                cell.textField.becomeFirstResponder()
            }
            if indexPath.row == 1 {
                categoryIsOpen()
            }
        case 1:
            if indexPath.row == numberOfIngridients-1 {
                print(numberOfIngridients)
                
                tableView.beginUpdates()
                tableView.insertRows(at: [IndexPath(row: numberOfIngridients-1, section: 1)], with: .automatic)
                numberOfIngridients += 1
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.endUpdates()
            }
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddRecipeViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewTitles.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewTitles[row]
    }
}

class AddRecipeTableViewCell: UITableViewCell {
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.delegate = self
    }
}

extension AddRecipeTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        
        return true
    }
}

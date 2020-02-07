import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var pickerStackView: UIStackView!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var pickerViewBackground: UIView!
    @IBOutlet var topViewPickerStackView: UIView!
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func readyButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickerCancelButtonAction(_ sender: Any) {
        pickerViewAnimation()
    }
    
    @IBAction func pickerReadyButtonAction(_ sender: Any) {
        pickerViewAnimation()
    }
    
    let weekdays: [Weekdays] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
    
    var pickerViewTitles: [String]!
    
    var pickerStackViewIsHidden: Bool!
    var pickerStackViewPositionOff: CGFloat!
    var pickerStackViewPositionOn: CGFloat!
    
    var breakfastList: [Recipe] = []
    var dinnerList: [Recipe] = []
    var dinner2List: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRecipes()
        
        pickerStackViewIsHidden = true

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: (UIApplication.shared.keyWindow?.safeAreaInsets.bottom)!, right: 0)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsTableViewCell")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if pickerStackViewPositionOff == nil {
            pickerStackViewPositionOff = self.view.frame.height
            pickerStackViewPositionOn = pickerStackViewPositionOff - pickerStackView.frame.height
            
            pickerStackView.frame.origin.y = pickerStackViewPositionOff
            
            topViewPickerStackView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            topViewPickerStackView.layer.cornerRadius = topViewPickerStackView.frame.height/3
            
            pickerViewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }
    }
    
    func loadRecipes() {
        let fetchedController = CoreDataManager.instance.getFetchedResultsController(forEntity: Entity.Recipe, keyForSort: "name")
        
        do {
            try fetchedController.performFetch()
        } catch {}
        
        let recipes = fetchedController.fetchedObjects as! [Recipe]
        
        recipes.forEach({ recipe in
            switch recipe.category {
            case "Завтрак": breakfastList.append(recipe)
            case "Обед": dinnerList.append(recipe)
            case "Ужин": dinner2List.append(recipe)
            default: break
            }
        })
    }
}

// MARK: - PickerViewAnimations
extension SettingsViewController {
    
    func pickerViewAnimation() {
        
        if pickerStackViewIsHidden {
            self.pickerStackView.isHidden = false
            self.pickerViewBackground.isHidden = false
        }
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 1.0,
            initialSpringVelocity: 1.0,
            options: [.curveEaseIn],
            animations: {
                if self.pickerStackViewIsHidden {
                    self.pickerStackView.frame.origin.y = self.pickerStackViewPositionOn
                    self.pickerViewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                } else {
                    self.pickerStackView.frame.origin.y = self.pickerStackViewPositionOff
                    self.pickerViewBackground.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                }
            },
            completion: { _ in
                if !self.pickerStackViewIsHidden {
                    self.pickerStackView.isHidden = true
                    self.pickerViewBackground.isHidden = true
                }
                self.pickerStackViewIsHidden = !self.pickerStackViewIsHidden
            }
        )
    }
    
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        weekdays.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return weekdays[section].description(isShort: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row) --- \(indexPath.section)"
        cell.textLabel?.textColor = UIColor(named: "primaryPlusColor")
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        pickerViewTitles = []
        switch indexPath.row {
        case 0:
            breakfastList.forEach({ recipe in
                pickerViewTitles.append(recipe.name!)
            })
        case 1:
            dinnerList.forEach({ recipe in
                pickerViewTitles.append(recipe.name!)
            })
        case 2:
            dinner2List.forEach({ recipe in
                pickerViewTitles.append(recipe.name!)
            })
            
        default: break
        }
        
        pickerView.reloadComponent(0)
        print(pickerView.numberOfRows(inComponent: 0))
        pickerViewAnimation()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: - UIPickerViewDataSource & UIPickerViewDelegate
extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let titles = pickerViewTitles {
            return titles.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title = pickerViewTitles[row]
        let attributedTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "primaryColor") as Any])
        
        return attributedTitle
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return pickerViewTitles[row]
//    }
}

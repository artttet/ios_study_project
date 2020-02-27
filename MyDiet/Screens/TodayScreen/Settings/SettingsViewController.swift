import UIKit

class SettingsViewController: UIViewController {
    // MARK: -  Views
    var settingsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Settings", comment: "")
        label.textColor = .primary
        label.font = .preferredFont(forTextStyle: .headline)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var closeButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        
        button.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        button.setTitleColor(.primary, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        
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
    let tableViewReuseId = "TableViewCell"
    
    var completionFunc: (() -> Void)!
    
    var recipes: [[Recipe]] = [[], [], []]
    
    var lastSelectedIndexPath: IndexPath!

    // MARK: - Overriden Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        loadRecipes()
        
        setupViews()
        setupConstraints()
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
    func loadRecipes() {
        let recipes = RecipesScreenDataManager.instance.getRecipeList(withSortKey: "name")
        
        recipes.forEach({ recipe in
            switch recipe.category {
            case 0: self.recipes[0].append(recipe)
            case 1: self.recipes[1].append(recipe)
            case 2: self.recipes[2].append(recipe)
            default: break
            }
        })
    }

}

// MARK: - Setup Views
extension SettingsViewController {
    func setupViews() {
        view.addSubview(settingsLabel)
        
        view.addSubview(closeButton)
        
        view.addSubview(separator)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewReuseId)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        view.addSubview(tableView)
        
        view.addSubview(backgroundView)
        
        pickerStackView.delegate = self
        view.addSubview(pickerStackView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        settingsLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8).isActive = true
        settingsLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        
        closeButton.centerYAnchor.constraint(equalTo: settingsLabel.centerYAnchor).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -12.0).isActive = true
        
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        separator.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 8).isActive = true
        separator.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        separator.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        pickerStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.40).isActive = true
        pickerStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        pickerStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
}

// MARK: - Actions
extension SettingsViewController {
    @objc func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
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

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TodayScreenDataManager.WeekdayKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let index = section == 6 ? 0 : section + 1
        let name = TodayScreenDataManager.WeekdayKeys[index]
        
        return String.localized(name)
    }
    
    func getRecipeName(for indexPath: IndexPath) -> String {
        let key = indexPath.section == 6 ? 0 : indexPath.section + 1
        
        let names = UserDefaults.standard.array(forKey: TodayScreenDataManager.WeekdayKeys[key]) as! [String]
        
        return names[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeName = getRecipeName(for: indexPath)
        var textColor: UIColor!
        
        if recipeName == "" { textColor = .lightGray }
        else { textColor = .primaryPlus }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewReuseId, for: indexPath)
        cell.textLabel?.text = recipeName == "" ? String.localized("Not_selected") : recipeName
        cell.textLabel?.textColor = textColor
        
        return cell
    }
}

// MARK: - UItableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let titleInRow = tableView.cellForRow(at: indexPath)?.textLabel?.text
        var selectedIndexForPicker: Int?
        
        var titles: [String] = [.localized("Not_selected")]
        
        recipes[indexPath.row].forEach({ recipe in
            titles.append(recipe.name!)
            if titles.contains(recipe.name!) {
                selectedIndexForPicker = titles.firstIndex(of: titleInRow!)
            }
        })
        
        lastSelectedIndexPath = indexPath
        
        pickerStackView.updateTitles(to: titles, with: selectedIndexForPicker!)
        animatePickerStackView()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - PickerStackViewDelegate
extension SettingsViewController: PickerStackViewDelegate {
    func cancelButtonDidTap() {
        animatePickerStackView()
    }
    
    func readyButtonDidTap() {
        let key = lastSelectedIndexPath.section == 6 ? 0 : lastSelectedIndexPath.section + 1
        var newRecipeName = pickerStackView.titles[pickerStackView.selectedRow()]
        
        if newRecipeName == String.localized("Not_selected") {
            newRecipeName = ""
        }
        TodayScreenDataManager.instance.changeDish(on: newRecipeName, inCategory: lastSelectedIndexPath.row, forKey: TodayScreenDataManager.WeekdayKeys[key])
        
        tableView.reloadData()
        animatePickerStackView()
        
        TodayScreenDataManager.instance.updateDishes()
        if let function = completionFunc {
            function()
        }
    }
}

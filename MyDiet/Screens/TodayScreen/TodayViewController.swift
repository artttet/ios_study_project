import UIKit
import FSPagerView
import BEMCheckBox

class TodayViewController: UIViewController {
    
    // MARK: - Views
    var todayLabel: UILabel = {
        let label = UILabel()
        label.text = .localized("Today")
        label.textColor = .primary
        label.font = .screenTitle
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var monthLabel: UILabel = {
        let label = UILabel()
        label.text = .localized(AppCalendar.instance.getMonth().name)
        label.textColor = .primary
        label.font = .preferredFont(forTextStyle: .headline)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var settingsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        button.backgroundColor = .background
        button.tintColor = .primary
        
        let image = UIImage(systemName: "gear")
        button.setImage(image, for: .normal)
        button.setPreferredSymbolConfiguration(.buttonImageConfiguration, forImageIn: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var calendarPagerView: CalendarPagerView = {
        let pagerView = CalendarPagerView()
        
        pagerView.translatesAutoresizingMaskIntoConstraints = false
        return pagerView
    }()
    
    var cardsPagerView: CardsPagerView = {
        let pagerView = CardsPagerView()
        
        pagerView.translatesAutoresizingMaskIntoConstraints = false
        return pagerView
    }()
    
    // MARK: - Properties
    let calendarReuseId = "CalendarPagerViewCell"
    let cardsReuseId = "CardsPagerViewCell"
    
    var appDayList: [AppDay]!
    
    var selectedIndex: Int!
    
    var style: UIStatusBarStyle = .default
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    
    // MARK: - Overriden Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDayList = TodayScreenDataManager.instance.getAppDayList(withSortKey: "dayNumber")
        
        selectedIndex = AppCalendar.instance.day - 1

        setupViews()
        setupConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCardsPagerView), name: .reloadCardsPagerView, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if cardsPagerView.itemSize == CGSize(width: 0.0, height: 0.0) {
            cardsPagerView.itemSize = CGSize(width: cardsPagerView.frame.width * 0.72, height: cardsPagerView.frame.height * 0.94)
        }
        
        perform(#selector(scrollPagersToSelected), with: nil, afterDelay: 0.0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Public Functions
    @objc func reloadCardsPagerView() {
        appDayList = TodayScreenDataManager.instance.getAppDayList(withSortKey: "dayNumber")
        cardsPagerView.reloadData()
    }
    
    func updateSelected(at appDayIndex: Int) {
        appDayList[selectedIndex].isSelected = false
        self.selectedIndex = appDayIndex
        appDayList[selectedIndex].isSelected = true
        calendarPagerView.reloadData()
    }
}

// MARK: - Setup Views
extension TodayViewController {
    func setupViews() {
        style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        view.backgroundColor = UIColor.background
        
        view.addSubview(todayLabel)
        
        view.addSubview(monthLabel)
        
        view.addSubview(settingsButton)
        
        calendarPagerView.dataSource = self
        calendarPagerView.delegate = self
        calendarPagerView.register(CalendarPagerViewCell.self, forCellWithReuseIdentifier: calendarReuseId)
        view.addSubview(calendarPagerView)
        
        cardsPagerView.dataSource = self
        cardsPagerView.delegate = self
        cardsPagerView.register(UINib(nibName: cardsReuseId, bundle: nil), forCellWithReuseIdentifier: cardsReuseId)
        view.addSubview(cardsPagerView)
    }
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        todayLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 32).isActive = true
        todayLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 32).isActive = true
        
        monthLabel.leadingAnchor.constraint(equalTo: todayLabel.leadingAnchor).isActive = true
        monthLabel.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: 8).isActive = true
        
        settingsButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        settingsButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -32).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: todayLabel.centerYAnchor, constant: 0).isActive = true
        
        calendarPagerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        calendarPagerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        calendarPagerView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 4).isActive = true
        calendarPagerView.heightAnchor.constraint(equalToConstant: 72).isActive = true
        
        cardsPagerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        cardsPagerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        cardsPagerView.topAnchor.constraint(equalTo: calendarPagerView.bottomAnchor, constant: 8.0).isActive = true
        cardsPagerView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
}

// MARK: - Actions
extension TodayViewController {
    
    @objc func settingsButtonAction() {
        let destinationVC = SettingsViewController()
        destinationVC.completionFunc = reloadCardsPagerView
        self.present(destinationVC, animated: true, completion: nil)
    }
}

// MARK: - Scroll Pagers Functions
extension TodayViewController {
    
    @objc
    func scrollPagersToSelected(animated: Bool) {
        
        if !animated {
            calendarPagerView.isUserInteractionEnabled = true
            cardsPagerView.isUserInteractionEnabled = true
        }
        
        if selectedIndex < appDayList.count - 2 {
            calendarPagerView.scrollToItem(at: selectedIndex + 2, animated: animated)
        }
        cardsPagerView.scrollToItem(at: selectedIndex, animated: animated)
    }
    
    func scrollPagers(to index: Int, animated: Bool) {
        if index < appDayList.count - 2 {
            calendarPagerView.scrollToItem(at: index + 2, animated: animated)
        }
        cardsPagerView.scrollToItem(at: index, animated: animated)
    }
}

// MARK: - FSPagerViewDataSource
extension TodayViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        appDayList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let appDay = appDayList[index]
        let dayNumber = Int(appDay.dayNumber)
        let weekday = AppCalendar.instance.getWeekday(fromDayNumber: dayNumber, isShort: true)
        
        // - Calendar Pager View cellForItemAt
        if pagerView is CalendarPagerView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: calendarReuseId, at: index) as! CalendarPagerViewCell
            
            cell.dayNumberLabel.text = "\(dayNumber)"
            cell.dayNameLabel.text = weekday.name
            
            cell.updateView(state: appDay.isSelected)
            
            return cell
        }
        
        // - Cards Pager View cellForItemAt
        if pagerView is CardsPagerView {
            let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cardsReuseId, at: index) as! CardsPagerViewCell
            cell.delegate = self
            cell.dayNumber = dayNumber
            
            let dayName = AppCalendar.instance.getWeekday(fromDayNumber: dayNumber, isShort: false).name
            cell.dayNameLabel.text = "\(dayName), \(dayNumber)"
            
            let dishes = [appDay.breakfast, appDay.dinner, appDay.dinner2]
            cell.checkboxes.forEach({ cb in
                let dishName = dishes[cb.tag]?.name
                let dishState: Bool = dishName == "" ? false : true
                
                cb.on = dishState ? dishes[cb.tag]!.isEaten : false
                cb.tintColor = dishState ? UIColor.primary : UIColor.lightGray
                cb.isUserInteractionEnabled = dishState
                
                cell.labels[cb.tag].isUserInteractionEnabled = dishState
                cell.labels[cb.tag].textColor = dishState ? cell.labelTextColor(state: cb.on) : UIColor.lightGray
                cell.labels[cb.tag].text = dishState ? dishName : String.localized("Not_selected")
            })
            
            return cell
        }
        
        return FSPagerViewCell()
    }
}

// MARK: - FSPagerViewDelegate
extension TodayViewController: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        updateSelected(at: index)
        scrollPagersToSelected(animated: true)
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        pagerView.isUserInteractionEnabled = false
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        pagerView.isUserInteractionEnabled = true
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        pagerView.isUserInteractionEnabled = true
        
        if pagerView is CardsPagerView {
            updateSelected(at: pagerView.currentIndex)
            scrollPagersToSelected(animated: true)
        }
    }
}

// MARK: - CardsPagerViewCellDelegate
extension TodayViewController: CardsPagerViewCellDelegate {
    func cardsPagerViewCell(checkboxDidTap checkbox: BEMCheckBox, cardDayNumber: Int) {
        TodayScreenDataManager.instance.changeIsEaten(at: cardDayNumber - 1, withTag: checkbox.tag, state: checkbox.on)
    }
    
    func cardsPagerViewCell(dishLabelDidTap label: UILabel) {
        var recipeNameForPresent: Recipe!
        
         let recipeList = RecipesScreenDataManager.instance.getRecipeList(withSortKey: "name")
         
         if let recipeName = recipeList.first(where: { $0.name == label.text }) {
             recipeNameForPresent = recipeName
         }
           
         let recipePageViewController = RecipePageViewController(nibName: "RecipePageViewController", bundle: nil)
         recipePageViewController.recipe = recipeNameForPresent
         recipePageViewController.modalPresentationStyle = .fullScreen
           
         self.present(recipePageViewController, animated: true, completion: nil)
    }
}



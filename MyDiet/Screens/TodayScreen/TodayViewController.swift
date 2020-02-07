import UIKit
import FSPagerView
import BEMCheckBox
import CoreData

class TodayViewController: UIViewController {
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var calendarPagerView: CalendarPagerView!
    @IBOutlet var cardsPagerView: CardsPagerView!
    
    
    @IBAction func settingsButtonAction(_ sender: Any) {
        let destinationVC = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    
    // Индекс для текущего дня
    static var selectedDay: Int = -1
    
    var style: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodayViewController.selectedDay = AppCalendar.instance.day - 1
    
        style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        monthLabel.text = AppCalendar.instance.getMonth().name
        
        let appDayList = TodayScreenDataManager.instance.getAppDayList(withSortKey: "dayNumber")
        
        calendarPagerView.appDayList = appDayList
        
        cardsPagerView.appDayList = appDayList
        cardsPagerView.monthNumber = AppCalendar.instance.getMonth().number
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform(#selector(userInteractionEnable), with: nil, afterDelay: 0.0)
        
        reloadPagerViews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollPagerViews(_:)), name: .init(Notifications.ScrollPagerViews.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkboxTapped(_:)), name: .init(Notifications.CheckboxTapped.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPagerViews), name: .init(Notifications.ReloadPagerViews.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openRecipePage(_:)), name: .init(Notifications.OpenRecipePage.rawValue), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .init(Notifications.ScrollPagerViews.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: .init( Notifications.CheckboxTapped.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: .init( Notifications.ReloadPagerViews.rawValue), object: nil)
        NotificationCenter.default.removeObserver(self, name: .init(Notifications.OpenRecipePage.rawValue), object: nil)
    }
    
    @objc
    func userInteractionEnable() {
        calendarPagerView.isUserInteractionEnabled = true
        cardsPagerView.isUserInteractionEnabled = true
    }
    
    @objc
    func scrollPagerViews(_ notification: Notification) {
        let object = notification.object as! [String : Any]
        if let index = object["index"] as? Int{
            calendarPagerView.scrollTo(index: index)
            TodayViewController.selectedDay = index
            cardsPagerView.scrollToItem(at: index, animated: true)
        }
    }
    
    @objc
    func checkboxTapped(_ notification: Notification) {
        let object = notification.object as! [String : Any]
        let checkBox = object["checkBox"] as! BEMCheckBox
        let index = object["index"] as! Int
        
        TodayScreenDataManager.instance.changeIsEaten(in: index, withTag: checkBox.tag, state: checkBox.on)
    }
    
    @objc
    func reloadPagerViews() {
        TodayScreenDataManager.instance.updateDishes()
        
        let appDayList = TodayScreenDataManager.instance.getAppDayList(withSortKey: "dayNumber")
        
        calendarPagerView.appDayList = appDayList
        calendarPagerView.reloadData()
        
        cardsPagerView.appDayList = appDayList
        cardsPagerView.reloadData()
    }
    
    @objc
    func openRecipePage(_ notification: Notification) {
        var recipeForPresent: Recipe!
        
        let object = notification.object as! [String : Any?]
        let recipeName = object["recipeName"] as! String
        
        let recipeList = RecipesScreenDataManager.instance.getRecipeList(withSortKey: "name")
           
        recipeList.forEach({ recipe in
            if recipe.name == recipeName {
                recipeForPresent = recipe
            }
        })
           
        let recipePageViewController = RecipePageViewController(nibName: "RecipePageViewController", bundle: nil)
        recipePageViewController.recipe = recipeForPresent
        recipePageViewController.modalPresentationStyle = .fullScreen
           
        self.present(recipePageViewController, animated: true, completion: nil)
    }
}




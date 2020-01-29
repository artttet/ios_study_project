import UIKit
import FSPagerView
import BEMCheckBox

class TodayViewController: UIViewController {
    @IBOutlet var cardsPagerView: CardsPagerView!
    @IBOutlet var calendarPagerView: CalendarPagerView!
    @IBOutlet var monthLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    
    static var selectedDay: Int = -1
    
    var style: UIStatusBarStyle = .default
    
    let fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "AppDay", keyForSort: "dayNumber")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        }catch {
            print(error)
        }
        
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        //let appDaysList = fetchedResultsController.fetchedObjects as! [AppDay]
        
        TodayViewController.selectedDay = AppCalendar.instance.day - 1
        
        monthLabel.text = AppCalendar.instance.getMonth().name
        
        calendarPagerView.appDaysList = fetchedResultsController.fetchedObjects as! [AppDay]
        
        cardsPagerView.appDaysList = fetchedResultsController.fetchedObjects as! [AppDay]
        cardsPagerView.monthNumber = AppCalendar.instance.getMonth().number
        
        NotificationCenter.default.addObserver(self, selector: #selector(needScroll), name: .init("NeedScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkBoxTapped), name: .init("CheckBoxTapped"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform(#selector(isUserEnable), with: nil, afterDelay: 0.0)
    }
    
    func reloadPagerViews() {
        let fetched = CoreDataManager.instance.fetchedResultsController(entityName: "AppDay", keyForSort: "dayNumber")
        let appDaysList = fetched.fetchedObjects as! [AppDay]
        
        calendarPagerView.appDaysList = appDaysList
        calendarPagerView.reloadData()
        
        cardsPagerView.appDaysList = appDaysList
        cardsPagerView.reloadData()
    }
    
    @objc
    func isUserEnable() {
        calendarPagerView.isUserInteractionEnabled = true
        cardsPagerView.isUserInteractionEnabled = true
    }
    
    @objc func needScroll(notifi: Notification) {
        if let index = notifi.userInfo?["index"] as? Int {
            calendarPagerView.scrollTo(index: index)
            TodayViewController.selectedDay = index
            cardsPagerView.scrollToItem(at: index, animated: true)
        }
    }
    
    @objc func checkBoxTapped(notifi: Notification) {
        let object = notifi.object as! [String : Any]
        let checkBox = object["checkBox"] as! BEMCheckBox
        let index = object["index"] as! Int
        
        TodayScreenDataManager.instance.changeIsEaten(in: index, withTag: checkBox.tag, state: checkBox.on)
    }
}




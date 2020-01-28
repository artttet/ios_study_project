import UIKit
import FSPagerView
import BEMCheckBox

class TodayViewController: UIViewController {
    @IBOutlet var cardsPagerView: CardsPagerView!
    @IBOutlet var calendarPagerView: CalendarPagerView!
    @IBOutlet var monthLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    var selectedDay: Int = -1
    var style: UIStatusBarStyle = .default
    
    let fetchedResultsController = CoreDataManager.instance.fetchedResultsController(entityName: "AppDay", keyForSort: "dayNumber")
    
    @objc
    func isUserEnable() {
        calendarPagerView.isUserInteractionEnabled = true
        cardsPagerView.isUserInteractionEnabled = true
    }
    
    @objc func needScroll(notifi: Notification) {
        if let index = notifi.userInfo?["index"] as? Int {
            selectedDay = index
            calendarPagerView.pagerViewScrollTo(index: index)
            cardsPagerView.scrollToItem(at: selectedDay, animated: true)
        }
    }
    
    @objc func checkBoxTapped(notifi: Notification) {
        let object = notifi.object as! [String : Any]
        let checkBox = object["checkBox"] as! BEMCheckBox
        let index = object["index"] as! Int
        
        TodayScreenDataManager.instance.changeIsEaten(in: index, withTag: checkBox.tag, state: checkBox.on)
    }
    
    func reloadPagerViews() {
        let daysList = fetchedResultsController.sections as! [AppDay]
        
        calendarPagerView.fetchedResultController = fetchedResultsController
        calendarPagerView.reloadData()
        
        cardsPagerView.fetchedResultController = fetchedResultsController
        cardsPagerView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
        }catch {
            print(error)
        }
        
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        let appDaysList = fetchedResultsController.sections as! [AppDay]
        selectedDay = AppCalendar.instance.day
        
        monthLabel.text = AppCalendar.instance.getMonth().name
        
        calendarPagerView.fetchedResultController = fetchedResultsController
        calendarPagerView.selectedDay = selectedDay-1
        
        cardsPagerView.fetchedResultController = fetchedResultsController
        cardsPagerView.monthNumber = AppCalendar.instance.getMonth().number
        cardsPagerView.currentDay = selectedDay
        
        NotificationCenter.default.addObserver(self, selector: #selector(needScroll), name: .init("NeedScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkBoxTapped), name: .init("CheckBoxTapped"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarPagerView.setupView()
        cardsPagerView.setupView()
        
        cardsPagerView.scrollToItem(at: selectedDay-1, animated: false)
        perform(#selector(isUserEnable), with: nil, afterDelay: 0.0)
    }
}




import UIKit
import FSPagerView

class TodayViewController: UIViewController {
    
    let dataController: TodayViewDataController = TodayViewDataController()
    var pagerViewsIndex: Int = 0
    
    @IBOutlet var cardsPagerView: CardsPagerView!
    @IBOutlet var calendarPagerView: CalendarPagerView!
    @IBOutlet var monthLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let calendarDaysList = dataController.calendarDaysList
        let cardDaysList = dataController.cardDaysList
        let currentDay = dataController.currentDay
        
        monthLabel.text = dataController.getMonth().1
        
        
        calendarPagerView.setupView(calendarDaysList: calendarDaysList, currentDay: currentDay)
        cardsPagerView.setupView(cardDaysList: cardDaysList, currentDay: currentDay, monthNumber: dataController.getMonth().0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pagerViewsTapped), name: .init("PagerViewsTapped"), object: nil)
    }
    
    @objc func pagerViewsTapped(notifi: Notification){
        if let index = notifi.userInfo?["index"] as? Int{
            calendarPagerView.didTap(index: index)
            cardsPagerView.didTap(index: index)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calendarPagerView.setupTransform()
        cardsPagerView.setupTransform()
    }
}

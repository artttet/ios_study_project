import UIKit
import FSPagerView

class TodayViewController: UIViewController {
    @IBOutlet var cardsPagerView: CardsPagerView!
    @IBOutlet var calendarPagerView: CalendarPagerView!
    @IBOutlet var monthLabel: UILabel!
    
    let dataController: TodayScreenData = TodayScreenData()
    
    static var selectedDay: Int = -1
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    var style: UIStatusBarStyle = .default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        let calendarDaysList = dataController.calendarDaysList
        let cardDaysList = dataController.cardDaysList
        TodayViewController.selectedDay = dataController.currentDay
        
        monthLabel.text = dataController.getMonth().str
        
        calendarPagerView.setupData(calendarDaysList: calendarDaysList)
        cardsPagerView.setupData(cardDaysList: cardDaysList, monthNumber: dataController.getMonth().int, currentDay: TodayViewController.selectedDay)
        
        NotificationCenter.default.addObserver(self, selector: #selector(needScroll), name: .init("NeedScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataController.dishMarkOn), name: .init("DishTapped"), object: nil)
    }
    
    @objc func needScroll(notifi: Notification){
        if let index = notifi.userInfo?["index"] as? Int{
            TodayViewController.selectedDay = index
            calendarPagerView.pagerViewScrollTo(index: index)
            cardsPagerView.pagerViewScrollTo(index: index)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calendarPagerView.setupView()
        cardsPagerView.setupView()
    }
}




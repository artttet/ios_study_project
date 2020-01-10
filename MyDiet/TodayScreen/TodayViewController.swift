import UIKit
import FSPagerView

class TodayViewController: UIViewController {
    
    let dataController: TodayScreenData = TodayScreenData()
    
    @IBOutlet var cardsPagerView: CardsPagerView!
    @IBOutlet var calendarPagerView: CalendarPagerView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var tittle: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return self.style }
    var style: UIStatusBarStyle = .default
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.style = .darkContent
        setNeedsStatusBarAppearanceUpdate()
        
        
        
        let calendarDaysList = dataController.calendarDaysList
        let cardDaysList = dataController.cardDaysList
        let currentDay = dataController.currentDay
        
        monthLabel.text = dataController.getMonth().1
        
        calendarPagerView.setupView(calendarDaysList: calendarDaysList, currentDay: currentDay)
        cardsPagerView.setupView(cardDaysList: cardDaysList, currentDay: currentDay, monthNumber: dataController.getMonth().0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pagerViewsTapped), name: .init("PagerViewsTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataController.dishMarkOn), name: .init("DishTapped"), object: nil)
    }
    
    @objc func pagerViewsTapped(notifi: Notification){
        if let index = notifi.userInfo?["index"] as? Int{
            calendarPagerView.didTap(index: index)
            cardsPagerView.didTap(index: index)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //navigationController?.navigationBar.barStyle = .white
        
        calendarPagerView.setupTransform()
        cardsPagerView.setupTransform()
    }
}

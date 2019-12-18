import UIKit
import FSPagerView

class TodayViewController: UIViewController {
    
    var imageNames = ["1.jpg","2.jpg","3.jpg","4.jpg","1.jpg","1.jpg","1.jpg"]
           var numberOfItems = 7
    
    @IBOutlet var cardsPagerView: CardsPagerView!
    @IBOutlet var calendarPagerView: CalendarPagerView!
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        cardsPagerView.setupView()
        calendarPagerView.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cardsPagerView.setupTransform()
        calendarPagerView.setupTransform()
    }
}

import UIKit
import FSPagerView
import CoreData

class CalendarPagerView: FSPagerView {
    
    let reuseId = "CalendarPagerViewCell"
    var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = NSFetchedResultsController()
    var selectedDay: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        register(UINib(nibName: reuseId, bundle: Bundle(identifier: reuseId)), forCellWithReuseIdentifier: reuseId)
    }
    
    func setupView(){
        let transform = CGAffineTransform(scaleX: 0.16, y: 1)
        itemSize = frame.size.applying(transform)
        
        let countItems = numberOfItems(in: self)
        
        if selectedDay != countItems-1 && selectedDay != countItems-2 {
            scrollToItem(at: selectedDay+2, animated: false)
        }else {
            scrollToItem(at: selectedDay, animated: false)
        }
    }
    
    func selectNew(index: Int){
        var indexPath = IndexPath.init(row: selectedDay, section: 0)
        var appDay = fetchedResultController.object(at: indexPath) as! AppDay
        appDay.isSelected = false
        
        selectedDay = index
        
        indexPath = IndexPath.init(row: selectedDay, section: 0)
        appDay = fetchedResultController.object(at: indexPath) as! AppDay
        appDay.isSelected = true
    }
    
    func pagerViewScrollTo(index: Int){
        selectNew(index: index)
        reloadData()
        let countItems = numberOfItems(in: self)
        if index != countItems-1 && index != countItems-2 {
            scrollToItem(at: index+2, animated: true)
        }
    }
}

extension CalendarPagerView: FSPagerViewDataSource, FSPagerViewDelegate {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return fetchedResultController.fetchedObjects!.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseId, at: index) as! CalendarPagerViewCell
        let appDay = fetchedResultController.object(at: IndexPath(row: index, section: 0)) as! AppDay
        
        cell.number = index
        cell.dayNameLabel.text = AppCalendar.instance.day(fromDayNumber: Int(appDay.dayNumber), isShort: true).dayName
        cell.dayNumberLabel.text = "\(appDay.dayNumber)"
        
        cell.updateView(isCurrent: appDay.isSelected)
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let message:[String: Int] = ["index": index]
        NotificationCenter.default.post(name: .init("NeedScroll"), object: nil, userInfo: message)
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = false
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = true
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = true
    }
}

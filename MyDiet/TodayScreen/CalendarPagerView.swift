import UIKit
import FSPagerView
import CoreData

class CalendarPagerView: FSPagerView {
    let reuseId = "CalendarPagerViewCell"
    
    var appDaysList: [AppDay] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        register(UINib(nibName: reuseId, bundle: Bundle(identifier: reuseId)), forCellWithReuseIdentifier: reuseId)
        perform(#selector(setupView), with: nil, afterDelay: 0.0)
    }
    
    @objc
    func setupView(){
        let transform = CGAffineTransform(scaleX: 0.16, y: 1)
        itemSize = frame.size.applying(transform)
        
        let countItems = numberOfItems(in: self)
        
        let selectedDay = TodayViewController.selectedDay
        if selectedDay != countItems-1 && selectedDay != countItems-2 {
            scrollToItem(at: selectedDay+2, animated: false)
        }else {
            scrollToItem(at: selectedDay, animated: false)
        }
    }
    
    func selectNew(index: Int){
        appDaysList[TodayViewController.selectedDay].isSelected = false
        
        appDaysList[index].isSelected = true
    }
    
    func scrollTo(index: Int){
        TodayViewController.selectedDay = index
        reloadData()
        let countItems = numberOfItems(in: self)
        if index != countItems-1 && index != countItems-2 {
            scrollToItem(at: index+2, animated: true)
        }
    }
}

extension CalendarPagerView: FSPagerViewDataSource{
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return appDaysList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseId, at: index) as! CalendarPagerViewCell
        let appDay = appDaysList[index]
        
        cell.number = index
        cell.dayNameLabel.text = AppCalendar.instance.day(fromDayNumber: Int(appDay.dayNumber), isShort: true).dayName
        cell.dayNumberLabel.text = "\(appDay.dayNumber)"
        
        if index == TodayViewController.selectedDay {
            cell.updateView(isCurrent: true)
        }else {
            cell.updateView(isCurrent: false)
        }
        
        return cell
    }
}

extension CalendarPagerView: FSPagerViewDelegate {
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let message: [String : Int] = ["index" : index]
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

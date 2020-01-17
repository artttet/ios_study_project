import UIKit
import FSPagerView

class CalendarPagerView: FSPagerView {
    
    let reuseId = "CalendarPagerViewCell"
    var calendarDaysList: [CalendarDay] = []
    var selectedDay: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        register(UINib(nibName: reuseId, bundle: Bundle(identifier: reuseId)), forCellWithReuseIdentifier: reuseId)
    }
    
    func setupData(calendarDaysList: [CalendarDay]){
        self.calendarDaysList = calendarDaysList
        self.selectedDay = TodayViewController.selectedDay
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
        self.isUserInteractionEnabled = true
    }
    
    func selectNew(index: Int){
        calendarDaysList[selectedDay].isSelected = false
        selectedDay = index
        calendarDaysList[selectedDay].isSelected = true
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
        return calendarDaysList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseId, at: index) as! CalendarPagerViewCell
        let calendarDay = calendarDaysList[index]
        
        cell.number = index
        cell.dayNameLabel.text = calendarDay.dayName
        cell.dayNumberLabel.text = "\(calendarDay.dayNumber)"
        
        cell.updateView(isCurrent: calendarDay.isSelected)
        
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
}

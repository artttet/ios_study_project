import UIKit
import FSPagerView

class CalendarPagerView: FSPagerView, FSPagerViewDataSource, FSPagerViewDelegate {
    
    let reuseId = "CalendarPagerViewCell"
    
    var calendarDaysList: [CalendarDay] = []
    var currentDay: Int = 0
    var selectedDay: Int = 0
    
    func setupView(calendarDaysList: [CalendarDay], currentDay: Int){
        dataSource = self
        delegate = self
        
        self.calendarDaysList = calendarDaysList
        self.currentDay = currentDay
        self.selectedDay = currentDay
        
        register(UINib(nibName: reuseId, bundle: Bundle(identifier: reuseId)), forCellWithReuseIdentifier: reuseId)
    }
    
    func setupTransform(){
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
        calendarDaysList[selectedDay].isSelected = false
        selectedDay = index
        calendarDaysList[selectedDay].isSelected = true
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return calendarDaysList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseId, at: index) as! CalendarPagerViewCell
        let calendarDay = calendarDaysList[index]
        
        cell.setData(calendarDay: calendarDay)
        
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let message:[String: Int] = ["index": index]

        NotificationCenter.default.post(name: .init("PagerViewsTapped"), object: nil, userInfo: message)
    }
    
    func didTap(index: Int){
        selectNew(index: index)
        reloadData()
        let countItems = numberOfItems(in: self)
        if index != countItems-1 && index != countItems-2 {
            scrollToItem(at: index+2, animated: true)
        }
    }
    
}

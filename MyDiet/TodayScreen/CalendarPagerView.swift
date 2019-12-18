import UIKit
import FSPagerView

struct AppCalendar {
    var dayName: String
    var dayNumber: String
}

class CalendarPagerView: FSPagerView, FSPagerViewDataSource, FSPagerViewDelegate {
    
    func setupView(){
        dataSource = self
        delegate = self
        
        
        register(UINib(nibName: "CalendarPagerViewCell", bundle: Bundle(identifier: "CalendarPagerViewCell")), forCellWithReuseIdentifier: "CalendarPagerViewCell")
    }
    
    func setupTransform(){
        let transform = CGAffineTransform(scaleX: 0.16, y: 1)
        itemSize = frame.size.applying(transform)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        30
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "CalendarPagerViewCell", at: index) as! CalendarPagerViewCell
        cell.setupView()
        let date = Date()
        let calendar = Calendar.current
        print(calendar.component(.day, from: date))
        cell.setDay(dayNumber: index+1)
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        let cell = cellForItem(at: index) as! CalendarPagerViewCell
        cell.isSelect = true
        cell.setupView()
        
    }
    
}

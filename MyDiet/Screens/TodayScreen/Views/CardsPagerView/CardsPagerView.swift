import FSPagerView
import UIKit
import BEMCheckBox
import CoreData

class CardsPagerView: FSPagerView {
    
    let reuseId: String = "CardsPagerViewCell"
    
    var appDayList: [AppDay] = []
    
    var monthNumber: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        transformer = FSPagerViewTransformer(type: .linear)
        register(UINib(nibName: reuseId, bundle: nil), forCellWithReuseIdentifier: reuseId)
        perform(#selector(setupView), with: nil, afterDelay: 0.0)
    }
    
    @objc
    func setupView() {
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.95)
        itemSize = frame.size.applying(transform)
        scrollToItem(at: TodayViewController.selectedDay, animated: false)
    }
    
    private func postScrollPagerViewsNotification(index: Int) {
        let object: [String : Int] = ["index" : index]
        NotificationCenter.default.post(name: .init(Notifications.ScrollPagerViews.rawValue), object: object)
    }
}

extension CardsPagerView: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return appDayList.count
    }
    
    private func createData(index: Int) -> (appDay: AppDay, monthNumber: String) {
        var monthNum: String
        if self.monthNumber < 10 {
            monthNum = "0\(self.monthNumber)"
        } else {
            monthNum = "\(self.monthNumber)"
        }
        
        return (appDayList[index], monthNum)
    }
    
    private func setTextColor(_ isEaten: Bool) -> UIColor {
        if isEaten {
            return UIColor(named: "primaryColor")!
        }else {
            return UIColor.white
        }
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseId, at: index) as! CardsPagerViewCell
        let data = createData(index: index)
        let appDay = data.appDay
        
        cell.number = Int(appDay.dayNumber)
        
        let dayName = AppCalendar.instance.getWeekday(fromDayNumber: Int(appDay.dayNumber), isShort: false).name
        cell.dayNameLabel.text = "\(dayName), \(appDay.dayNumber).\(data.monthNumber)"
        
        cell.breakfastLabel.text = appDay.breakfast!.name
        cell.breakfastLabel.textColor = setTextColor(appDay.breakfast!.isEaten)
        cell.breakfastCB.on = appDay.breakfast!.isEaten
        
        cell.dinnerLabel.text = appDay.dinner!.name
        cell.dinnerLabel.textColor = setTextColor(appDay.dinner!.isEaten)
        cell.dinnerCB.on = appDay.dinner!.isEaten
        
        cell.dinner2Label.text = appDay.dinner2!.name
        cell.dinner2Label.textColor = setTextColor(appDay.dinner2!.isEaten)
        cell.dinner2CB.on = appDay.dinner2!.isEaten
        
        cell.delegate = self
        
        //cell.setupView()
        
        if cell.number != AppCalendar.instance.day {
            cell.breakfastCB.isUserInteractionEnabled = false
            cell.dinnerCB.isUserInteractionEnabled = false
            cell.dinner2CB.isUserInteractionEnabled = false
        } else {
            cell.breakfastCB.isUserInteractionEnabled = true
            cell.dinnerCB.isUserInteractionEnabled = true
            cell.dinner2CB.isUserInteractionEnabled = true
        }
        
        return cell
    }
}

extension CardsPagerView: FSPagerViewDelegate {
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = false
        
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = true
        postScrollPagerViewsNotification(index: pagerView.currentIndex)
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = true
    }
}

extension CardsPagerView: CardsPagerViewCellDelegate {
    
    func cardTapped(_ collectionViewCell: CardsPagerViewCell) {
        postScrollPagerViewsNotification(index: collectionViewCell.number-1)
    }
    
    func checkboxTapped(_ checkBox: BEMCheckBox, dayNumber: Int) {
        let object: [String : Any] = ["index" : index, "checkBox" : checkBox]
        NotificationCenter.default.post(name: .init(Notifications.CheckboxTapped.rawValue), object: object)
    }
}

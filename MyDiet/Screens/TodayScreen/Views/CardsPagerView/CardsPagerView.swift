import FSPagerView
import UIKit
import BEMCheckBox
import CoreData

class CardsPagerView: FSPagerView {
    
    lazy var breakfastLabelTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        return t
    }()
    
    lazy var dinnerLabelTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        return t
    }()
    
    lazy var dinner2LabelTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        return t
    }()
    
    let reuseId: String = "CardsPagerViewCell"
    
    var appDayList: [AppDay] = []
    
    var monthNumber: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        transformer = FSPagerViewTransformer(type: .linear)
        register(UINib(nibName: reuseId, bundle: nil), forCellWithReuseIdentifier: reuseId)

        // Устанавливает размер карточек после того, как CardsPagerView "загрузится"
        perform(#selector(setupCards), with: nil, afterDelay: 0.0)
    }
    
    @objc
    func labelTapped(_ sender: UITapGestureRecognizer) {
        let senderView = sender.view as! UILabel
        let object: [String : Any?] = ["recipeName" : senderView.text]
        NotificationCenter.default.post(name: .init(Notifications.OpenRecipePage.rawValue), object: object)
    }
    
    @objc
    func setupCards() {
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.95)
        self.itemSize = self.frame.size.applying(transform)
        isHidden = true
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: .curveEaseIn,
            animations: {
                self.isHidden = false
            },
            completion: nil
        )
        scrollToItem(at: TodayViewController.selectedDay, animated: false)
    }
    
    private func postScrollPagerViewsNotification(index: Int) {
        let object: [String : Any] = ["index" : index]
        NotificationCenter.default.post(name: .init(Notifications.ScrollPagerViews.rawValue), object: object)
    }
}

// MARK: - FSPagerViewDataSource
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
        
        if let dish = appDay.breakfast {
            cell.breakfastLabel.text = dish.name
            if dish.name != "Не выбрано" {
                cell.breakfastLabel.textColor = setTextColor(dish.isEaten)
                
                cell.breakfastCB.tintColor = UIColor(named: "primaryColor")!
                cell.breakfastCB.on = dish.isEaten
                
                if cell.number != AppCalendar.instance.day {
                    cell.breakfastLabel.isUserInteractionEnabled = false
                    cell.breakfastCB.isUserInteractionEnabled = false
                } else {
                    cell.breakfastLabel.isUserInteractionEnabled = true
                    cell.breakfastLabel.addGestureRecognizer(breakfastLabelTap)
                    
                    cell.breakfastCB.isUserInteractionEnabled = true
                }
            } else {
                cell.breakfastLabel.textColor = UIColor.lightGray
                cell.breakfastLabel.isUserInteractionEnabled = false
                
                cell.breakfastCB.tintColor = UIColor.lightGray
                cell.breakfastCB.isUserInteractionEnabled = false
                cell.breakfastCB.on = false
            }
        }
        
        if let dish = appDay.dinner {
            cell.dinnerLabel.text = dish.name
            if dish.name != "Не выбрано" {
                cell.dinnerLabel.textColor = setTextColor(dish.isEaten)
                
                cell.dinnerCB.tintColor = UIColor(named: "primaryColor")!
                cell.dinnerCB.on = dish.isEaten
                
                if cell.number != AppCalendar.instance.day {
                    cell.dinnerLabel.isUserInteractionEnabled = false
                    cell.dinnerCB.isUserInteractionEnabled = false
                } else {
                    cell.dinnerLabel.isUserInteractionEnabled = true
                    cell.dinnerLabel.addGestureRecognizer(dinnerLabelTap)
                    
                    cell.dinnerCB.isUserInteractionEnabled = true
                }
            } else {
                cell.dinnerLabel.textColor = UIColor.lightGray
                cell.dinnerLabel.isUserInteractionEnabled = false
                
                cell.dinnerCB.tintColor = UIColor.lightGray
                cell.dinnerCB.isUserInteractionEnabled = false
                cell.dinnerCB.on = false
            }
        }
    
        if let dish = appDay.dinner2 {
            cell.dinner2Label.text = dish.name
            if dish.name != "Не выбрано" {
                cell.dinner2Label.textColor = setTextColor(dish.isEaten)
                
                cell.dinner2CB.tintColor = UIColor(named: "primaryColor")!
                cell.dinner2CB.on = dish.isEaten
                
                if cell.number != AppCalendar.instance.day {
                    cell.dinner2Label.isUserInteractionEnabled = false
                    cell.dinner2CB.isUserInteractionEnabled = false
                } else {
                    cell.dinner2Label.isUserInteractionEnabled = true
                    cell.dinner2Label.addGestureRecognizer(dinner2LabelTap)
                    
                    cell.dinner2CB.isUserInteractionEnabled = true
                }
            } else {
                cell.dinner2Label.textColor = UIColor.lightGray
                cell.dinner2Label.isUserInteractionEnabled = false
                
                cell.dinner2CB.tintColor = UIColor.lightGray
                cell.dinner2CB.isUserInteractionEnabled = false
                cell.dinner2CB.on = false
            }
        }
        
        return cell
    }
}

// MARK: - FSPagerViewDelegate
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

// MARK: - CardsPagerViewCellDelegate
extension CardsPagerView: CardsPagerViewCellDelegate {
    
    func cardTapped(_ collectionViewCell: CardsPagerViewCell) {
        postScrollPagerViewsNotification(index: collectionViewCell.number-1)
    }
    
    func checkboxTapped(_ checkBox: BEMCheckBox, dayNumber: Int) {
        let object: [String : Any] = ["index" : dayNumber-1, "checkBox" : checkBox]
        NotificationCenter.default.post(name: .init(Notifications.CheckboxTapped.rawValue), object: object)
    }
}

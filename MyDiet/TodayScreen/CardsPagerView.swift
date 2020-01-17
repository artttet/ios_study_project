import UIKit
import FSPagerView

class CardsPagerView: FSPagerView {
    
    var currentDay: Int = 0
    
    let reuseId: String = "CardsPagerViewCell"
    var cardDaysList: [CardDay] = []
    var monthNumber: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dataSource = self
        delegate = self
        transformer = FSPagerViewTransformer(type: .linear)
        register(UINib(nibName: reuseId, bundle: nil), forCellWithReuseIdentifier: reuseId)
    }
    
    func setupData(cardDaysList: [CardDay], monthNumber: Int, currentDay: Int){
        self.cardDaysList = cardDaysList
        self.monthNumber = monthNumber
        self.currentDay = currentDay
    }
    
    func setupView(){
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.95)
        itemSize = frame.size.applying(transform)
        
        scrollToItem(at: TodayViewController.selectedDay, animated: false)
        self.isUserInteractionEnabled = true
    }
    
    func pagerViewScrollTo(index: Int){
        scrollToItem(at: index, animated: true)
    }
    
    fileprivate func createAndPostMessage(index: Int, name: String) {
        let message:[String: Int] = ["index": index]
        NotificationCenter.default.post(name: .init(name), object: nil, userInfo: message)
    }
    
}

extension CardsPagerView: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return cardDaysList.count
    }
    
    private func createData(index: Int) -> (cardDay: CardDay, monthNumber: String) {
        var monthNum: String
        if self.monthNumber < 10 {
            monthNum = "0\(self.monthNumber)"
        } else {
            monthNum = "\(self.monthNumber)"
        }
        
        return (self.cardDaysList[index], monthNum)
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseId, at: index) as! CardsPagerViewCell
        let data = createData(index: index)
        let cardDay = data.cardDay
        
        cell.number = index
        cell.dayNameLabel.text = "\(cardDay.weekdayName), \(index+1).\(data.monthNumber)"
        cell.breakfastLabel.text = cardDay.breakfast.dishName
        cell.dinnerLabel.text = cardDay.dinner.dishName
        cell.dinner2Label.text = cardDay.dinner2.dishName
        
        cell.delegate = self
        cell.setupView()
        if index+1 < currentDay {
            cell.breakfastCB.isUserInteractionEnabled = false
            cell.dinnerCB.isUserInteractionEnabled = false
            cell.dinner2CB.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = true
        createAndPostMessage(index: pagerView.currentIndex, name: "NeedScroll")
    }
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = false
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.isUserInteractionEnabled = true
    }
    
}

extension CardsPagerView: CardsPagerViewCellDelegate {
    func cardDidTap(_ collectionViewCell: CardsPagerViewCell) {
        createAndPostMessage(index: collectionViewCell.number, name: "NeedScroll")
    }
}

import UIKit
import FSPagerView

class CardsPagerView: FSPagerView, FSPagerViewDataSource, FSPagerViewDelegate {
    
    let reuseId: String = "CardsPagerViewCell"
    var cardDaysList: [CardDay] = []
    var currentDay: Int = 0
    var monthNumber: Int = 0
    
    func setupView(cardDaysList: [CardDay], currentDay: Int, monthNumber: Int){
        dataSource = self
        delegate = self
        
        self.cardDaysList = cardDaysList
        self.currentDay = currentDay
        self.monthNumber = monthNumber
        
        transformer = FSPagerViewTransformer(type: .linear)
        
        register(UINib(nibName: reuseId, bundle: nil), forCellWithReuseIdentifier: reuseId)
    }
    
    func setupTransform(){
        let transform = CGAffineTransform(scaleX: 0.75, y: 0.95)
        itemSize = frame.size.applying(transform)
        
        scrollToItem(at: currentDay, animated: false)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return cardDaysList.count
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        scrollToItem(at: index, animated: true)
       
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: reuseId, at: index) as! CardsPagerViewCell
        cell.setData(cardDay: cardDaysList[index], monthNumber: self.monthNumber, number: index)
        return cell
    }
    
    func didTap(index: Int){
        scrollToItem(at: index, animated: true)
    }
}

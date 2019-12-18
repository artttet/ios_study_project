import UIKit
import FSPagerView

class CardsPagerView: FSPagerView, FSPagerViewDataSource, FSPagerViewDelegate {
    
    var imageNames = ["1.jpg","2.jpg","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg"]
    
    func setupView(){
        dataSource = self
        delegate = self
        
        transformer = FSPagerViewTransformer(type: .linear)
        
        //backgroundColor = UIColor.purple
        
        register(UINib(nibName: "CardsPagerViewCell", bundle: nil), forCellWithReuseIdentifier: "CardsPagerViewCell")
    }
    
    func setupTransform(){
        let transform = CGAffineTransform(scaleX: 0.8, y: 1)
        itemSize = frame.size.applying(transform)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return imageNames.count
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        scrollToItem(at: index, animated: true)
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "CardsPagerViewCell", at: index) as! CardsPagerViewCell
        cell.setDay(dayName: imageNames[index])
        return cell
    }
}

import UIKit
import FSPagerView

class CardsPagerViewCell: FSPagerViewCell {
    var number: Int = 0
    
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var cardView: GradientView!
    
    @IBOutlet var breakfastLabel: UILabel!
    @IBOutlet var dinnerLabel: UILabel!
    @IBOutlet var dinner2Label: UILabel!
    
    func setData(cardDay: CardDay, monthNumber: Int, number: Int) {
        self.number = number
        dayNameLabel.text = "\(cardDay.weekdayName), \(number+1).\(monthNumber)"
        breakfastLabel.text = cardDay.breakfast.dishName
        dinnerLabel.text = cardDay.dinner.dishName
        dinner2Label.text = cardDay.dinner2.dishName
        
        setupView()
    }
    
    func setupView(){
        cardView.layer.shadowColor = UIColor(named: "primaryDarkColor")?.cgColor
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4	)
        cardView.layer.shadowOpacity = 1
    }

}

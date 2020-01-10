import UIKit
import FSPagerView
import BEMCheckBox

class CardsPagerViewCell: FSPagerViewCell, BEMCheckBoxDelegate {
    
    var checkboxes: [BEMCheckBox]?
    var number: Int = 0
    
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var cardView: GradientView!
    
    @IBOutlet var view: UIView!
    
    @IBOutlet var breakfastLabel: UILabel!
    @IBOutlet var dinnerLabel: UILabel!
    @IBOutlet var dinner2Label: UILabel!
    
    @IBOutlet var breakfastCB: BEMCheckBox!
    @IBOutlet var dinnerCB: BEMCheckBox!
    @IBOutlet var dinner2CB: BEMCheckBox!
    
    func setData(cardDay: CardDay, monthNumber: Int, number: Int) {
        self.number = number+1
        
        var monthNum: String
        if monthNumber < 10 {
            monthNum = "0\(monthNumber)"
        } else {
            monthNum = "\(monthNumber)"
        }
        dayNameLabel.text = "\(cardDay.weekdayName), \(self.number).\(monthNum)"
        breakfastLabel.text = cardDay.breakfast.dishName
        dinnerLabel.text = cardDay.dinner.dishName
        dinner2Label.text = cardDay.dinner2.dishName
        
        checkboxes = [breakfastCB, dinnerCB, dinner2CB]
        
        setupView()
    }
    
    func setupView(){
        cardView.layer.shadowColor = UIColor(named: "primaryDarkColor")?.cgColor
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4	)
        cardView.layer.shadowOpacity = 1
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        let currentTag = checkBox.tag
        print("tapped")
        guard let checkboxes = checkboxes else{ return }
        for box in checkboxes
            where box.tag != currentTag {
            box.on = false
        }
    }

}

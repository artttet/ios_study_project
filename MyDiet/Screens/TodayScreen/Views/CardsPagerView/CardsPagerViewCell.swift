import UIKit
import FSPagerView
import BEMCheckBox

protocol CardsPagerViewCellDelegate: AnyObject {
    func cardTapped(_ collectionViewCell: CardsPagerViewCell)
    func checkboxTapped(_ checkBox: BEMCheckBox, dayNumber: Int)
}

class CardsPagerViewCell: FSPagerViewCell, BEMCheckBoxDelegate {
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var cardView: GradientView!
    
    @IBOutlet var breakfastLabel: UILabel!
    @IBOutlet var dinnerLabel: UILabel!
    @IBOutlet var dinner2Label: UILabel!
    
    @IBOutlet var breakfastCB: BEMCheckBox!
    @IBOutlet var dinnerCB: BEMCheckBox!
    @IBOutlet var dinner2CB: BEMCheckBox!
    
    lazy var cardDidTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.cardTapped(_:)))
        return t
    }()
    
    lazy var breakfastCheckBoxDidTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.checkboxTapped(_:)))
        return t
    }()
    
    lazy var dinnerCheckBoxDidTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.checkboxTapped(_:)))
        return t
    }()
    
    lazy var dinner2CheckBoxDidTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.checkboxTapped(_:)))
        return t
    }()
    
    weak var delegate: CardsPagerViewCellDelegate?
    
    var checkboxes: [BEMCheckBox]?
    
    var number: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkboxes = [breakfastCB, dinnerCB, dinner2CB]
        
        setupCardView()
        
        breakfastCB.addGestureRecognizer(breakfastCheckBoxDidTap)
        dinnerCB.addGestureRecognizer(dinnerCheckBoxDidTap)
        dinner2CB.addGestureRecognizer(dinner2CheckBoxDidTap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Позволяет кликать по элементам внутри cell'a
        contentView.removeFromSuperview()
    }
    
    @objc
    func setupCardView() {
        cardView.shadowColor = UIColor(named: "primaryDarkColor")!
        cardView.shadowBlur = 10
        cardView.shadowX = 0
        cardView.shadowY = 8
        cardView.shadowOpacity = 0.8
        
        cardView.isUserInteractionEnabled = true
        cardView.addGestureRecognizer(cardDidTap)
    }
    
    @objc
    func cardTapped(_ sender: UITapGestureRecognizer) {
        delegate?.cardTapped(self)
    }
    
    @objc
    func checkboxTapped(_ sender: UITapGestureRecognizer) {
        let checkBox = sender.view as! BEMCheckBox
        let tag = checkBox.tag
        
        if checkBox.on {
            let color = UIColor.white
            checkBox.setOn(false, animated: true)
            switch tag {
            case 0:
                breakfastLabel.textColor = color
            case 1:
                dinnerLabel.textColor = color
            case 2:
                dinner2Label.textColor = color
            default:
                break
            }
        } else if !checkBox.on {
            let color = UIColor(named: "primaryColor")
            checkBox.setOn(true, animated: true)
            switch tag {
            case 0:
                breakfastLabel.textColor = color
            case 1:
                dinnerLabel.textColor = color
            case 2:
                dinner2Label.textColor = color
            default:
                break
            }
        }
        
        delegate?.checkboxTapped(checkBox, dayNumber: number)
    }
    
    
    
    
}

extension CardsPagerViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}




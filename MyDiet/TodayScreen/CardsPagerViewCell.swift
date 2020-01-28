import UIKit
import FSPagerView
import BEMCheckBox

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
        let t = UITapGestureRecognizer(target: self, action: #selector(self.cardDidTap(_:)))
        return t
    }()
    
    lazy var breakfastCheckBoxDidTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.checkBoxDidTap(_:)))
        return t
    }()
    
    lazy var dinnerCheckBoxDidTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.checkBoxDidTap(_:)))
        return t
    }()
    
    lazy var dinner2CheckBoxDidTap: UITapGestureRecognizer = {
        let t = UITapGestureRecognizer(target: self, action: #selector(self.checkBoxDidTap(_:)))
        return t
    }()
    
    weak var delegate: CardsPagerViewCellDelegate?
    var checkboxes: [BEMCheckBox]?
    var number: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkboxes = [breakfastCB, dinnerCB, dinner2CB]
        
        cardView.isUserInteractionEnabled = true
        cardView.addGestureRecognizer(cardDidTap)
        
        breakfastCB.addGestureRecognizer(breakfastCheckBoxDidTap)
        dinnerCB.addGestureRecognizer(dinnerCheckBoxDidTap)
        dinner2CB.addGestureRecognizer(dinner2CheckBoxDidTap)
        
    }
    
    @objc
    func checkBoxDidTap(_ sender: UITapGestureRecognizer) {
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
        
        delegate?.checkBoxDidTap(checkBox, dayNumber: number)
    }
    
    @objc
    func addShadow() {
        cardView.layer.shadowColor = UIColor(named: "primaryDarkColor")?.cgColor
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowOpacity = 1
    }
    
    func setupView(){
        perform(#selector(addShadow), with: nil, afterDelay: 0.0)
    }
   
    @objc
    func cardDidTap(_ sender: UITapGestureRecognizer) {
        delegate?.cardDidTap(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.removeFromSuperview()
    }

}

extension CardsPagerViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}


protocol CardsPagerViewCellDelegate: AnyObject {
    func cardDidTap(_ collectionViewCell: CardsPagerViewCell)
    func checkBoxDidTap(_ checkBox: BEMCheckBox, dayNumber: Int)
}

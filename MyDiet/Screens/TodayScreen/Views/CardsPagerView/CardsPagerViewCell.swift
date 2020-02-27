import UIKit
import BEMCheckBox
import FSPagerView

protocol CardsPagerViewCellDelegate: NSObjectProtocol {
    func cardsPagerViewCell(checkboxDidTap checkbox: BEMCheckBox, cardDayNumber: Int)
    func cardsPagerViewCell(dishLabelDidTap label: UILabel)
}

class CardsPagerViewCell: FSPagerViewCell {
    
    @IBOutlet var dayNameLabel: UILabel!
    @IBOutlet var cardView: GradientView!
    
    var checkboxes: [BEMCheckBox]!
    @IBOutlet var breakfastCB: BEMCheckBox!
    @IBOutlet var dinnerCB: BEMCheckBox!
    @IBOutlet var dinner2CB: BEMCheckBox!
    
    var labels: [UILabel]!
    @IBOutlet var breakfastLabel: UILabel!
    @IBOutlet var dinnerLabel: UILabel!
    @IBOutlet var dinner2Label: UILabel!
    
    weak var delegate: CardsPagerViewCellDelegate?
    
    var dayNumber: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labels = [breakfastLabel, dinnerLabel, dinner2Label]
        labels.forEach({ label in
            label.addGestureRecognizer(setGesture())
        })
        
        checkboxes = [breakfastCB, dinnerCB, dinner2CB]
        checkboxes.forEach({ cb in
            cb.delegate = self
            cb.animationDuration = 0.5
        })
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.removeFromSuperview()
    }
    
    @objc
    func dishLabelTapped(_ sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        delegate?.cardsPagerViewCell(dishLabelDidTap: label)
    }
    
    func setGesture() -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dishLabelTapped(_:)))
        return gestureRecognizer
    }
    
    func labelTextColor(state: Bool) -> UIColor {
        return state ? UIColor.primary : UIColor.white
    }
    
}

extension CardsPagerViewCell: BEMCheckBoxDelegate {
    func didTap(_ checkBox: BEMCheckBox) {
        checkBox.setOn(checkBox.on, animated: true)
        
        delegate?.cardsPagerViewCell(checkboxDidTap: checkBox, cardDayNumber: dayNumber)
    }
    
    func animationDidStop(for checkBox: BEMCheckBox) {
        labels[checkBox.tag].textColor = labelTextColor(state: checkBox.on)
    }
}

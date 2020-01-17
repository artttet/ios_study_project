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
    
    weak var delegate: CardsPagerViewCellDelegate?
    var checkboxes: [BEMCheckBox]?
    var number: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkboxes = [breakfastCB, dinnerCB, dinner2CB]
        
        cardView.isUserInteractionEnabled = true
        cardView.addGestureRecognizer(cardDidTap)
    }
    
    func setupView(){
        
        cardView.layer.shadowColor = UIColor(named: "primaryDarkColor")?.cgColor
        cardView.layer.shadowRadius = 8
        cardView.layer.shadowOffset = CGSize(width: 0, height: 8)
        cardView.layer.shadowOpacity = 1
        
    }
   
    @objc
    func cardDidTap(_ sender: UITapGestureRecognizer) {
        delegate?.cardDidTap(self)
    }
    
//    func didTap(_ checkBox: BEMCheckBox) {
//        print("\(checkBox.tag)")
//    }
    
    @objc func didTap(_ checkBox: BEMCheckBox) {
        let currentTag = checkBox.tag
        print("tapped")
        guard let checkboxes = checkboxes else{ return }
        for box in checkboxes
            where box.tag != currentTag {
            box.on = false
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.removeFromSuperview()
    }

}

protocol CardsPagerViewCellDelegate: AnyObject {
    func cardDidTap(_ collectionViewCell: CardsPagerViewCell)
}

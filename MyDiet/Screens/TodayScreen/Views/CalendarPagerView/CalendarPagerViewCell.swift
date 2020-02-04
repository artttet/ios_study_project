import UIKit
import FSPagerView

class CalendarPagerViewCell: FSPagerViewCell {
    @IBOutlet weak var view: UIView!
    
    @IBOutlet var dayNumberLabel: UILabel!
    @IBOutlet var dayNameLabel: UILabel!
    
    @IBOutlet var viewConstraintTop: NSLayoutConstraint!
    @IBOutlet var viewConstraintBottom: NSLayoutConstraint!
    @IBOutlet var viewConstraintLeft: NSLayoutConstraint!
    @IBOutlet var viewConstraintRight: NSLayoutConstraint!
    
    var number: Int = 0
    
    func setupView(isCurrent: Bool){
        view.layer.cornerRadius = 12
        
        if isCurrent {
            view.backgroundColor = UIColor(named: "primaryColor")
            
            view.layer.shadowColor = UIColor(named: "primaryColor")?.cgColor
            view.layer.shadowRadius = 4.0
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowOpacity = 1.0
            
            dayNumberLabel.textColor = .white
            dayNameLabel.textColor = .white
            
            viewConstraintTop.constant = 10
            viewConstraintBottom.constant = 10
            viewConstraintLeft.constant = 4
            viewConstraintRight.constant = 4
        } else {
            view.backgroundColor = UIColor(named: "primaryLightColor")
            
            view.layer.shadowOpacity = 0.0
            
            dayNumberLabel.textColor = UIColor(named: "primaryColor")
            dayNameLabel.textColor = UIColor(named: "primaryColor")
            
            viewConstraintTop.constant = 12
            viewConstraintBottom.constant = 12
            viewConstraintLeft.constant = 6
            viewConstraintRight.constant = 6
        }
    }
}



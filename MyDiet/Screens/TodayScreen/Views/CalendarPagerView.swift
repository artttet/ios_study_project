import UIKit
import FSPagerView
import BEMCheckBox

class CalendarPagerView: FSPagerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        itemSize = CGSize(width: 52, height: 52)
        interitemSpacing = 12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CalendarPagerViewCell: FSPagerViewCell {
    
    let dayNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primary
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    let dayNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.primary
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.primaryLight
        layer.cornerRadius = frame.size.height/4
        
        addSubview(dayNumberLabel)
        dayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        dayNumberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        dayNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addSubview(dayNameLabel)
        dayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        dayNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        dayNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView(state: Bool) {
        if state {
            backgroundColor = UIColor.primary
            dayNumberLabel.textColor = UIColor.white
            dayNameLabel.textColor = UIColor.white
            
            transform = .init(scaleX: 1.1, y: 1.1)
            layer.shadowColor = UIColor.primary.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 4
            layer.shadowOpacity = 1.0
        } else {
            backgroundColor = UIColor.primaryLight
            dayNumberLabel.textColor = UIColor.primary
            dayNameLabel.textColor = UIColor.primary
            
            transform = .init(scaleX: 1.0, y: 1.0)
            layer.shadowOpacity = 0.0
        }
    }
}

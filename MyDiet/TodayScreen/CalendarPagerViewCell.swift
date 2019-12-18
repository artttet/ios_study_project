//
//  CalendarPagerViewCell.swift
//  MyDiet
//
//  Created by Artas on 18/12/2019.
//  Copyright © 2019 Артем Чиглинцев. All rights reserved.
//

import UIKit
import FSPagerView

class CalendarPagerViewCell: FSPagerViewCell {

    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet var calendarViewConstraintTop: NSLayoutConstraint!
    @IBOutlet var calendarViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet var calendarViewConstraintLeft: NSLayoutConstraint!
    @IBOutlet var calendarViewConstraintRight: NSLayoutConstraint!
    
    var isSelect: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDay(dayNumber: Int) {
        day.text = "\(dayNumber)"
    }
    
    func setupView(){
        
        calendarView.layer.cornerRadius = 12.0
        
        if isSelect {
            calendarView.toSelected()
            day.textColor = .white
            calendarViewConstraintTop.constant = 12
            calendarViewConstraintBottom.constant = 12
            calendarViewConstraintLeft.constant = 6
            calendarViewConstraintRight.constant = 6
        }else {
            calendarView.layer.shadowOpacity = 0.0
        }
        
    }
    

}

extension UIView {
    func toSelected(){
        backgroundColor = UIColor(named: "primaryColor")
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 4.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 1.0
    }
}

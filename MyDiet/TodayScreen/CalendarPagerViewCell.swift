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

    var number: Int = 0
    
    @IBOutlet weak var calendarView: UIView!
    
    @IBOutlet var dayNumberLabel: UILabel!
    
    @IBOutlet var dayNameLabel: UILabel!
    
    @IBOutlet var calendarViewConstraintTop: NSLayoutConstraint!
    @IBOutlet var calendarViewConstraintBottom: NSLayoutConstraint!
    @IBOutlet var calendarViewConstraintLeft: NSLayoutConstraint!
    @IBOutlet var calendarViewConstraintRight: NSLayoutConstraint!
    
    var isSelect: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setDay(dayNumber: Int) {
        
    }
    
    func setData(calendarDay: CalendarDay){
        number = calendarDay.dayNumber
        dayNumberLabel.text = "\(calendarDay.dayNumber)"
        dayNameLabel.text = calendarDay.dayName
        
        updateView(isCurrent: calendarDay.isSelected)
    }
    
    func isCurrentView(isCurrent: Bool){
        if isCurrent {
            calendarView.backgroundColor = UIColor(named: "primaryColor")
            
            calendarView.layer.shadowColor = UIColor(named: "primaryColor")?.cgColor
            calendarView.layer.shadowRadius = 4.0
            calendarView.layer.shadowOffset = CGSize(width: 0, height: 0)
            calendarView.layer.shadowOpacity = 1.0
            
            dayNumberLabel.textColor = .white
            dayNameLabel.textColor = .white
            
            calendarViewConstraintTop.constant = 10
            calendarViewConstraintBottom.constant = 10
            calendarViewConstraintLeft.constant = 4
            calendarViewConstraintRight.constant = 4
        }else {
            calendarView.backgroundColor = UIColor(named: "primaryLightColor")
            
            calendarView.layer.shadowOpacity = 0.0
            
            dayNumberLabel.textColor = UIColor(named: "primaryColor")
            dayNameLabel.textColor = UIColor(named: "primaryColor")
            
            calendarViewConstraintTop.constant = 12
            calendarViewConstraintBottom.constant = 12
            calendarViewConstraintLeft.constant = 6
            calendarViewConstraintRight.constant = 6
        }
        
        
    }
    
    func updateView(isCurrent: Bool){
        calendarView.layer.cornerRadius = 12.0
        
        isCurrentView(isCurrent: isCurrent)
    }
}



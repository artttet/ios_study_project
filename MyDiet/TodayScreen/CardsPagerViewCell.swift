//
//  MainCard.swift
//  MyDiet
//
//  Created by Артем Чиглинцев on 16/12/2019.
//  Copyright © 2019 Артем Чиглинцев. All rights reserved.
//

import UIKit
import FSPagerView

class CardsPagerViewCell: FSPagerViewCell {
    
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    func setDay(dayName: String) {
        dayNameLabel.text = dayName
        setupView()
    }
    
    func setupView(){
        cardView.layer.cornerRadius = 12.0
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOffset = CGSize(width: 0, height: 5)
        cardView.layer.shadowOpacity = 1
        
        
    }
    
}

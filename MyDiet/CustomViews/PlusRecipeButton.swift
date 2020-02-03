//
//  PlusRecipeButton.swift
//  MyDiet
//
//  Created by Artas on 29/01/2020.
//  Copyright © 2020 Артем Чиглинцев. All rights reserved.
//

import Foundation
import UIKit

class PlusRecipeButton: UIButton {
    let touchDownAlpha: CGFloat = 0.65
    
    var color: UIColor = .black
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let backgroundColor = backgroundColor {
            color = backgroundColor
        }
        
        setup()
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                touchDown()
            } else {
                touchUp()
            }
        }
    }
    
    func touchDown() {
        let plusImage = subviews.first
        plusImage?.tintColor = UIColor.white.withAlphaComponent(0.6)
    }
    
    func touchUp() {
        let plusImage = subviews.first
        plusImage?.tintColor = UIColor.white.withAlphaComponent(1.0)
    }
    
    func setup() {
        backgroundColor = .clear
        layer.backgroundColor = color.cgColor
        
        layer.cornerRadius = 32
        clipsToBounds = false
        
        layer.shadowColor = UIColor(named: "accentColor")?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.7
        
    }
}

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
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super .endTracking(touch, with: event)

        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [.beginFromCurrentState, .allowUserInteraction],
            animations: {
                self.backgroundColor = UIColor(named: "accentColor")
                self.layer.shadowColor = UIColor(named: "accentColor")?.cgColor
                
                
            }
        )
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                touchDown()
            } else {
                cancelTracking(with: nil)
                touchUp()
            }
        }
    }
    
    func touchDown() {
        let highlightedColor = UIColor(named: "accentPlusButtonHighlightedColor")?.cgColor
        layer.backgroundColor = highlightedColor
        layer.shadowColor = highlightedColor
    }
    
    func touchUp() {
        
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

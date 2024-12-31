//
//  UITextFld+Extensions.swift
//  Cinemax
//
//  Created by IPS-177  on 23/04/24.
//

import Foundation
import UIKit

extension UITextField {
    func shake(duration:Double,repeatCount:Float,autoreverses:Bool){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = autoreverses
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}


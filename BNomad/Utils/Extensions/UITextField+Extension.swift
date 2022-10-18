//
//  UITextField+Extension.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/10/18.
//

import UIKit

extension UITextField {
    func setUnderLine(color: UIColor, width: CGFloat, height: CGFloat) {
        let border = CALayer()
        let weight = CGFloat(2)
        
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: height + 10, width: width - weight, height: weight)
        border.borderWidth = weight
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}

//
//  UILabel+Extension.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/10/18.
//

import UIKit

extension UILabel {
    func asColor(targetString: String, color: UIColor) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = attributedString
    }
}

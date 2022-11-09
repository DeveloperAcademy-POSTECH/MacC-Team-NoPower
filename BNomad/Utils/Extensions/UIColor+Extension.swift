//
//  UIColor+Extension.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/10/18.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var opacity: CGFloat = 1.0
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            opacity = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: red, green: green, blue: blue, alpha: opacity)
    }
}

class CustomColor {
    static let nomadBlack = UIColor(hex: "000000")
    static let nomadBlue = UIColor(hex: "148DAC")
    static let nomadGray1 = UIColor(hex: "8E8E93")
    static let nomadGray2 = UIColor(hex: "D1D1D6")
    static let nomadGray3 = UIColor(hex: "F4F4F4")
    static let nomadSkyblue = UIColor(hex: "82B5D2")
    static let nomadGreen = UIColor(hex: "5DC878")
    static let nomadRed = UIColor(hex: "FF6961")
}

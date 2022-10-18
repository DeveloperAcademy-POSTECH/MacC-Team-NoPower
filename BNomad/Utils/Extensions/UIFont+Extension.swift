//
//  UIFont+Extension.swift
//  BNomad
//
//  Created by Eunbee Kang on 2022/10/18.
//

import UIKit

extension UIFont {
    static func preferredFont(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let font = style.withWeight(weight)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
}

extension UIFont.TextStyle {
    var baseFont: UIFont {
        return UIFont.systemFont(ofSize: defaultPointSize, weight: defaultWeight)
    }
    
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        return UIFont.systemFont(ofSize: defaultPointSize, weight: weight)
    }
    
    var defaultWeight: UIFont.Weight {
        switch self {
        case .subheadline:
            return .bold
        default:
            return .regular
        }
    }
    
    var defaultPointSize: CGFloat {
        switch self {
        case .largeTitle:
            return 34
        case .title1:
            return 28
        case .title2:
            return 22
        case .title3:
            return 20
        case .headline:
            return 17
        case .body:
            return 17
        case .callout:
            return 16
        case .subheadline:
            return 15
        case .footnote:
            return 13
        case .caption1:
            return 12
        case .caption2:
            return 11
        default:
            return 17
        }
    }
}

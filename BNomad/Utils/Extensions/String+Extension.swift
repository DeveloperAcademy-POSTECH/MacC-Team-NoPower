//
//  String.swift
//  BNomad
//
//  Created by hyo on 2022/10/18.
//

import Foundation
import UIKit

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
    
    func toDateTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
    
    func dynamicHeight() -> CGFloat {
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 43, height: .greatestFiniteMagnitude))
        text.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.text = self
        text.textAlignment = .left
        text.sizeToFit()
        return text.frame.height
    }
}

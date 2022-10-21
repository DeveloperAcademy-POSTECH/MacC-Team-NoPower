//
//  String.swift
//  BNomad
//
//  Created by hyo on 2022/10/18.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
    
    func toDateTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: self)
    }
}

//
//  Date+Extension.swift
//  BNomad
//
//  Created by hyo on 2022/10/18.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let date_string = formatter.string(from: self)
        return date_string
    }
}

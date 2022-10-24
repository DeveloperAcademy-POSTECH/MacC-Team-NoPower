//
//  Date+Extension.swift
//  BNomad
//
//  Created by hyo on 2022/10/18.
//

import Foundation

extension Date {
    
    /// dateFormat = "yyyy-MM-dd" ex) 2021-10-18
    func toDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date_string = formatter.string(from: self)
        return date_string
    }
    /// dateFormat = "yyyy-MM-dd HH:mm:ss" ex) 2021-10-18 12:00:00
    func toDateTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date_string = formatter.string(from: self)
        return date_string
    }
}

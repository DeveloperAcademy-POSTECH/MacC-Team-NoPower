//
//  CheckIn.swift
//  BNomad
//
//  Created by hyo on 2022/10/18.
//

import Foundation

struct CheckIn {
    let userUid: String
    let placeUid: String
    let checkInUid: String
    let checkInTime: Date
    var checkOutTime: Date?
    var todayGoal: String?
    
    // ex) "2022-10-18"
    var date: String { checkInTime.toDateString() }
}

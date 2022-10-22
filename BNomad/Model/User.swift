//
//  User.swift
//  BNomad
//
//  Created by hyo on 2022/10/13.
//

import Foundation

struct User {
    let userUid: String
    var nickname: String
    var occupation: String?
    var introduction: String?
    var checkInHistory: [CheckIn]?

    var currentCheckIn: CheckIn? { checkInHistory?.first { $0.date == Date().toString() && $0.checkOutTime == nil} }
    var currentPlaceUid: String? { currentCheckIn?.placeUid }
    var isChecked: Bool { currentPlaceUid != nil ? true : false }
    
}

extension User {
    func toAnyObject() -> Any {
      return [
        "userUid": userUid,
        "nickname": nickname,
        "occupation": occupation,
        "introduction": introduction
      ]
    }
}

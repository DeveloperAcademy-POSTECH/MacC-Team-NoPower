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
    var placeUid: String?
    var occupation: String?

    var isChecked: Bool { placeUid != nil ? true : false }
}

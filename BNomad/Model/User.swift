//
//  User.swift
//  BNomad
//
//  Created by hyo on 2022/10/13.
//

import Foundation
import UIKit

struct User {
    let userUid: String
    var nickname: String
    var occupation: String?
    var introduction: String?
    var checkInHistory: [CheckIn]?
    
    var profileImageUrl: String?
    var profileImage: UIImage?
        
    var currentCheckIn: CheckIn? { checkInHistory?.first { $0.date == Date().toDateString() && $0.checkOutTime == nil} }
    var currentPlaceUid: String? { currentCheckIn?.placeUid }
    var isChecked: Bool { currentPlaceUid != nil ? true : false }
    
}

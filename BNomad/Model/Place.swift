//
//  Place.swift
//  BNomad
//
//  Created by hyo on 2022/10/13.
//

import Foundation

struct Place {
    let placeUid: String
    let name: String
    let latitude: Double
    let longitude: Double
    var contact: String?
    var address: String?
    var time: String?
    var type: PlaceType?
    var totalCheckInHistory: [CheckIn]?
    var todayCheckInHistory: [CheckIn]?
    
    // 현재 checkIn 데이터들
    var currentCheckIn: [CheckIn]? { todayCheckInHistory?.filter { $0.checkOutTime == nil } }
    
}

enum PlaceType: Int {
    case coworking
    case library
    case cafe
}

//
//  MeetUp.swift
//  BNomad
//
//  Created by hyo on 2022/11/07.
//

import Foundation

struct MeetUp {
    
    let meetUpUid: String
    let placeUid: String
    let organizerUid: String
    
    var title: String
    var meetUpPlaceName: String
    var time: Date
    var maxPeopleNum: Int
    
    var description: String?
    var currentPeopleUids: [String]?

    var date: String { time.toDateString()}
}

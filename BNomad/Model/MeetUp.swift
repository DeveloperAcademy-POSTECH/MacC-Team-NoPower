//
//  MeetUp.swift
//  BNomad
//
//  Created by hyo on 2022/11/07.
//

import Foundation

struct MeetUp {
    
    let questUid: String = UUID().uuidString
    var participantUid: [String] = []

    let placeUid: String
    let organizerUid: String
    
    var name: String
    var meetPlace: String
    var time: Date
    var maxNum: Int
    
    var memo: String?

    var date: String { time.toDateString()}
}

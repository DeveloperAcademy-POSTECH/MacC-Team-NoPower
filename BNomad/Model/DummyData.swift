//
//  DummyData.swift
//  BNomad
//
//  Created by hyo on 2022/10/13.
//

import Foundation

struct DummyData {
    
    static var user1: User = User(userUid: UUID().uuidString, nickname: "wil")
    static var user2: User = User(userUid: UUID().uuidString, nickname: "jin")
    static var user3: User = User(userUid: UUID().uuidString, nickname: "lance")

    static var place1: Place = Place(placeUid: UUID().uuidString, name: "니얼미", latitude: 36.0129, longitude: 129.3255, contact: "054-279-3720")
    static var place2: Place = Place(placeUid: UUID().uuidString, name: "애플디벨로퍼아카데미", latitude: 36.01411, longitude: 129.32587, contact: "054-279-0114")
    static var place3: Place = Place(placeUid: UUID().uuidString, name: "포스빌", latitude: 36.01511, longitude: 129.34587, contact: "054-279-0115")
    
}

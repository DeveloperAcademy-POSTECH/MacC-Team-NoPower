//
//  DummyData.swift
//  BNomad
//
//  Created by hyo on 2022/10/13.
//

import Foundation

struct DummyData {
    static var user1: User = User(userUid: UUID().uuidString, nickname: "wil", isChecked: true)
    static var user2: User = User(userUid: UUID().uuidString, nickname: "jin", isChecked: false)
    static var user3: User = User(userUid: UUID().uuidString, nickname: "lance", isChecked: true)

    static var place1: Place = Place(users: [user1], placeUid: UUID().uuidString, name: "니어미", latitude: 36.0129, longitude: 129.3255, contact: "054-279-3720")
    static var place2: Place = Place(users: [user3], placeUid: UUID().uuidString, name: "애플디벨로퍼아카데미", latitude: 36.01411, longitude: 129.32587, contact: "054-279-0114")
    static var place3: Place = Place(users: [], placeUid: UUID().uuidString, name: "포스빌", latitude: 36.01511, longitude: 129.34587, contact: "054-279-0115")
    
    static var poistion1: Position = Position(id: user1.userUid, latitude: 36.0128, longitude: 129.3265)
    static var poistion2: Position = Position(id: user2.userUid, latitude: 36.0152, longitude: 129.3465)
    static var poistion3: Position = Position(id: user3.userUid, latitude: 36.1248, longitude: 129.5265)
}

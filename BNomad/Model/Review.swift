//
//  Review.swift
//  BNomad
//
//  Created by hyo on 2022/11/10.
//

import Foundation

struct Review {
    let placeUid: String
    let userUid: String
    let reviewUid: String
    let createTime: Date
    var content: String
    var imageUrl: String?
}

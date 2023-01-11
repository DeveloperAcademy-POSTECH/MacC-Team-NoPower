//
//  CombineViewModel.swift
//  BNomad
//
//  Created by hyo on 2022/10/25.
//

import Foundation
import Combine

class CombineViewModel: ObservableObject {
    
    static let shared: CombineViewModel = CombineViewModel()
    
    @Published var user: User? {
        didSet {
            guard let isChecked = user?.isChecked else {
                checkIn = nil
                return
            }
            checkIn = isChecked
        }
    }
    @Published var checkIn: Bool?
    @Published var checkInPlace: Place? {
        didSet {
            checkInPlace = places.first { place in
                place.placeUid == user?.currentPlaceUid
            }
        }
    }
    @Published var placeInCurrentMap: [Place] = []
    
    var places: [Place] = []
    var isLogIn: Bool { user != nil }
}

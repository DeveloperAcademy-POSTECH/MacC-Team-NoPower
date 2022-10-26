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
    @Published var placeInCurrentMap: [Place] = [DummyData.place1, DummyData.place1, DummyData.place2] //
    
    var places: [Place] = []
    var isLogIn: Bool { user != nil }
}

//
//  CombineViewModel.swift
//  BNomad
//
//  Created by hyo on 2022/10/25.
//

import Foundation
import Combine

class CombineViewModel: ObservableObject {
    
    @Published var user: User?
    @Published var placeInCurrentMap: [Place] = [DummyData.place1, DummyData.place1, DummyData.place2] //
    var isLogIn = false
}

//
//  MapData.swift
//  BNomad
//
//  Created by Youngwoong Choi on 2022/10/19.
//

import Foundation
import MapKit

class PlaceToMKAnnotation: NSObject, MKAnnotation {
    
    enum PlaceType: Int {
        case coworking
        case library
        case cafe
    }
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title: String?
    var subtitle: String?
    var type: PlaceType = .coworking
}

// 더미 데이터에서 좌표 추출하여 MKAnnotation 형식으로 변환
func placeToAnnotation(_ place: Place) -> PlaceToMKAnnotation {
    let annotation = PlaceToMKAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
    annotation.title = place.name
    let randomNum = Int.random(in: 0...1)
    let randomType = PlaceToMKAnnotation.PlaceType(rawValue: randomNum)
    annotation.type = randomType ?? .coworking
    return annotation
}

let placeAnnotations: [MKAnnotation] = [
    placeToAnnotation(DummyData.place1),
    placeToAnnotation(DummyData.place2),
    placeToAnnotation(DummyData.place3)
]



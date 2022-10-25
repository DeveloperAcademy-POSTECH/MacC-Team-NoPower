//
//  MapData.swift
//  BNomad
//
//  Created by Youngwoong Choi on 2022/10/19.
//

import Foundation
import MapKit

// TODO: - 해당 파일 제거 후 Place의 extension으로 편입시키기
enum PlaceType: Int {
    case coworking
    case library
    case cafe
}

class PlaceToMKAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title: String?
    var subtitle: String?
    var type: PlaceType = .coworking
    
    // 더미 데이터에서 좌표 추출하여 MKAnnotation 형식으로 변환
    static func placeToAnnotation(_ place: Place) -> PlaceToMKAnnotation {
        let annotation = PlaceToMKAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        annotation.title = place.name
        // TODO: - 랜덤 제거 후 PlaceType이 nil 경우의 annotation 사용. 
        let randomNum = Int.random(in: 0...1)
        let randomType = PlaceType(rawValue: randomNum)
        annotation.type = randomType ?? .coworking
        return annotation
    }
}

let placeAnnotations: [MKAnnotation] = [
    PlaceToMKAnnotation.placeToAnnotation(DummyData.place1),
    PlaceToMKAnnotation.placeToAnnotation(DummyData.place2),
    PlaceToMKAnnotation.placeToAnnotation(DummyData.place3)
]



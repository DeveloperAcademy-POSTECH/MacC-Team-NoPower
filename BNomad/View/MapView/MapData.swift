//
//  MapData.swift
//  BNomad
//
//  Created by Youngwoong Choi on 2022/10/19.
//

import Foundation
import MapKit


class MKAnnotationFromPlace: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title: String?
    var subtitle: String?
    var placeUid: String?
    var type: PlaceType = .coworking
    
    // 더미 데이터에서 좌표 추출하여 MKAnnotation 형식으로 변환
    static func convertPlaceToAnnotation(_ place: Place) -> MKAnnotationFromPlace {
        let annotation = MKAnnotationFromPlace()
        annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        annotation.title = place.name
        annotation.placeUid = place.placeUid
//        // TODO: - 랜덤 제거 후 PlaceType이 nil 경우의 annotation 사용.
//        let randomNum = Int.random(in: 0...1)
//        let randomType = PlaceType(rawValue: randomNum)
        annotation.type = .coworking
        return annotation
    }
}


enum RegionName: String {
    case jeju1 = "제주 제주시"
    case jeju2 = "제주 서귀포시"
    case seoul = "서울"
    case gangwon = "강원"
    case jeolla = "전라"
    case gyeongsang = "경상"
    case gyeonggi = "경기"
    case chungcheong = "충청"
    case daegu = "대구"
    case busan = "부산"
    case ulsan = "울산"
    case gwangju = "광주"
    case incheon = "인천"
    case daejeon = "대전"
    case sejong = "세종"
    case pohang = "포항"
}

struct Region {
    let name: String
    let lat: Double
    let long: Double
    
    var coordiante: CLLocationCoordinate2D {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        return coordinate
    }
    
    let span: Double
    
    var convertedSpan: MKCoordinateSpan {
        let span = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        return span
    }
    
    var region: MKCoordinateRegion {
        let region = MKCoordinateRegion(center: coordiante, span: convertedSpan)
        return region
    }
    
    init(name: String, lat: Double, long: Double, span: Double) {
        self.name = name
        self.lat = lat
        self.long = long
        self.span = span
    }
}


// RegionData와 하단의 RegionArray는 갯수, 순서 일치시켜서 관리

struct RegionData {
    static let jeju1: Region = Region(name: "\(RegionName.jeju1.rawValue)", lat: 33.4974, long: 126.5164, span: 0.9)
    static let jeju2: Region = Region(name: "\(RegionName.jeju2.rawValue)", lat: 33.2327, long: 126.3003, span: 0.5)
    static let seoul: Region = Region(name: "\(RegionName.seoul.rawValue)", lat: 37.5542, long: 126.9733, span: 0.5)
    static let pohang: Region = Region(name: "\(RegionName.pohang.rawValue)", lat: 36.0137, long: 129.3257, span: 0.5)
    
    // 추후 지역 추가를 위해 남김
//    static var gangwon: Region = Region(name: "\(RegionName.gangwon.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var jeolla: Region = Region(name: "\(RegionName.jeolla.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var gyeongsang: Region = Region(name: "\(RegionName.gyeongsang.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var gyeonggi: Region = Region(name: "\(RegionName.gyeonggi.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var chungcheong: Region = Region(name: "\(RegionName.chungcheong.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var daegu: Region = Region(name: "\(RegionName.daegu.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var busan: Region = Region(name: "\(RegionName.busan.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var ulsan: Region = Region(name: "\(RegionName.ulsan.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var gwangju: Region = Region(name: "\(RegionName.gwangju.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var incheon: Region = Region(name: "\(RegionName.incheon.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var daejeon: Region = Region(name: "\(RegionName.daejeon.rawValue)", lat: 0, long: 0, span: 0.1)
//    static var sejong: Region = Region(name: "\(RegionName.sejong.rawValue)", lat: 0, long: 0, span: 0.1)

    
    static let regionArray: [Region] = [RegionData.jeju1, RegionData.jeju2, RegionData.seoul, RegionData.pohang]
}


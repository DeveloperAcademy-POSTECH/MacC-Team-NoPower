//
//  MapViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    lazy var currentLocation = locationManager.location
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    lazy var startRegion: MKCoordinateRegion = MKCoordinateRegion(center: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), span: span)
    
    // 맵 띄우기
    private lazy var map: MKMapView = {
        let map = MKMapView()
        map.setRegion(startRegion, animated: false)
        map.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: [.airport, .beach, .campground, .publicTransport]))
        map.showsScale = false
        map.showsCompass = false
        map.userTrackingMode = .follow
        map.showsUserLocation = true
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // 맵 회전 시에만 일시적으로 등장하는 나침반
    private lazy var compass: MKCompassButton = {
        let compass = MKCompassButton(mapView: map)
        compass.compassVisibility = .adaptive
        compass.translatesAutoresizingMaskIntoConstraints = false
        return compass
    }()
    
    // 기본 버튼들 (프로필, 세팅, 유저 위치)
    private let profileBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "person"), for: .normal)
        btn.tintColor = .systemGray
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return divider
    }()
    
    private let settingBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "gearshape"), for: .normal)
        btn.tintColor = .systemGray
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var profileAndSetting: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileBtn, divider, settingBtn])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 1
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var userTrackingBtn: MKUserTrackingButton = {
        let btn = MKUserTrackingButton(mapView: map)
        btn.backgroundColor = .white
        btn.tintColor = .systemGray
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    lazy var mapButtons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileAndSetting, userTrackingBtn])
        stackView.sizeToFit()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 2
        stackView.distribution = .equalCentering
        stackView.backgroundColor = .clear
        stackView.layer.cornerRadius = 10
        profileAndSetting.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileAndSetting.heightAnchor.constraint(equalToConstant: 90).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 추후 유저 위치 중심으로 circle overlay (radius distance 미터 단위)
    lazy var circleOverlay: MKCircle = {
        guard let location = currentLocation else { return MKCircle(center: CLLocationCoordinate2D(), radius: 0) }
        let circle = MKCircle(center: location.coordinate, radius: 500)
        return circle
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationAuthorization()
        configueMapUI()
//        registerAnnotationViewClasses()
        
    }
    
    // MARK: - Actions
    
    // 맵을 회전시켜 나침반이 등장한 상태로 유저 위치로 가기 버튼을 누르면 맵 회전된 상태 그대로 위치만 이동하고 있어서, 유저 위치로 갈 때 자동으로 정북 방향으로 회전까지 같이 시켜주는 방안 고민중입니다.
    func userTrackingToCompass() {
        if userTrackingBtn.isExclusiveTouch {
            
        }
    }
    
    
    // MARK: - Helpers
    
    // 위치 권한 받아서 현재 위치 확인
    func locationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    // 맵 UI 그리기
    func configueMapUI() {
        map.delegate = self
        view.addSubview(map)
        map.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

        map.addSubview(mapButtons)
        mapButtons.anchor(top: map.topAnchor, right: map.rightAnchor, paddingTop: 50, paddingRight: 20, width: 40, height: 140)
        
        map.addSubview(compass)
        compass.anchor(top: map.topAnchor, left: map.leftAnchor, paddingTop: 50, paddingLeft: 20, width: 40, height: 40)
        
        map.addOverlay(circleOverlay)
        map.addAnnotations(placeAnnotations)
    }
    
//    func registerAnnotationViewClasses() {
//        map.register(CoworkingAnnotationView.self, forAnnotationViewWithReuseIdentifier: "dda")
//        map.register(LibraryAnnotationView.self, forAnnotationViewWithReuseIdentifier: "dd")
//        map.register(CafePlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: "cafeAnnotaion")
//    }
    
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    // 맵 오버레이 rendering
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let overlay = MKCircleRenderer(circle: circleOverlay)
        overlay.strokeColor = .systemPink
        overlay.fillColor = .systemPink.withAlphaComponent(0.5)
        overlay.lineWidth = 2
        return overlay
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceToMKAnnotation else { return nil }

        switch annotation.type {
        case .coworking:
            return CoworkingAnnotationView(annotation: annotation, reuseIdentifier: CoworkingAnnotationView.ReuseID)
        case .cafe:
            return CafePlaceAnnotationView(annotation: annotation, reuseIdentifier: CafePlaceAnnotationView.ReuseID)
        case .library:
            return LibraryAnnotationView(annotation: annotation, reuseIdentifier: LibraryAnnotationView.ReuseID)
        }
    }
}

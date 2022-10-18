//
//  MapViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    
    let userLocation = MKUserLocation()
    let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1) // span을 바꾸어 적용하려고 해도 잘 안됩니다. setRegion에 변화를 줄 수 있는 방법을 계속 찾아볼 예정입니다.
    lazy var startRegion: MKCoordinateRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
    
    // 맵 띄우기
    lazy var map: MKMapView = {
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
    lazy var compass: MKCompassButton = {
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
    
    // 추후 유저 위치 중심으로 circle overlay 그릴 예정 (현재는 적용이 안되고 있습니다)
    lazy var circleOverlay: MKCircle = {
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: 36, longitude: 129), radius: 1000)
        return circle
    }()

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationAuthorization()
        configueMapUI()
        
        
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
    }
    
    // 맵 UI 그리기
    func configueMapUI() {
        map.delegate = self
        view.addSubview(map)
        map.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        map.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        map.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        map.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        map.addSubview(mapButtons)
        mapButtons.topAnchor.constraint(equalTo: map.topAnchor, constant: 50) .isActive = true
        mapButtons.rightAnchor.constraint(equalTo: map.rightAnchor, constant: -20).isActive = true
        mapButtons.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mapButtons.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        map.addSubview(compass)
        compass.topAnchor.constraint(equalTo: map.topAnchor, constant: 50) .isActive = true
        compass.leftAnchor.constraint(equalTo: map.leftAnchor, constant: 20).isActive = true
        compass.widthAnchor.constraint(equalToConstant: 40).isActive = true
        compass.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        map.addOverlay(circleOverlay)

    }
    
}


extension MapViewController: MKMapViewDelegate {
    
    // 맵 오버레이 관련 func
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        MKCircleRenderer(circle: circleOverlay)
    }
    
}

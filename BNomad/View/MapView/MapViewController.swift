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
    lazy var currentLocation: CLLocation? = locationManager.location
    let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    lazy var startRegion: MKCoordinateRegion = MKCoordinateRegion(center: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), span: span)
    
    // var user: User = DummyData.user1
    // var isLogin: Bool = false
    
    // 맵 띄우기
    private lazy var map: MKMapView = {
        let map = MKMapView()
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
    lazy var profileBtn: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "person"), for: .normal)
        btn.tintColor = .systemGray
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 10
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
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
    
    // TODO: - 장소 모달 뷰 보다가 현재 위치로 이동 시 보던 장소 모달 dismiss 필요
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
    
    // 유저 위치 중심으로 circle overlay (radius distance 미터 단위)
    // TODO: - 실시간으로 위치 이동 시 Circle도 따라가 계속 그려져야 함
    lazy var circleOverlay: MKCircle = {
        guard let location = currentLocation else { return MKCircle(center: CLLocationCoordinate2D(), radius: 0) }
        let circle = MKCircle(center: location.coordinate, radius: 500)
        return circle
    }()
    
    let workingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = CustomColor.nomadBlue?.cgColor
        return view
    }()
    
    // TODO: 제거하고 user.isChecked 사용
    var userCheckedIn: Bool = false
    
    lazy var listViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("리스트 보기", for:.normal)
        button.titleLabel!.font = .preferredFont(forTextStyle: .subheadline, weight: .bold)
        button.setTitleColor(CustomColor.nomadBlue, for: .normal)
        button.layer.cornerRadius = 20
        button.layer.borderColor = CustomColor.nomadBlue?.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentPlaceViewModal), for: .touchUpInside)
        return button
    }()

    @objc private func presentPlaceViewModal() {
        let sheet = CustomModalViewController()
        sheet.modalPresentationStyle = .pageSheet
        if let sheet = sheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.delegate = self
            sheet.prefersGrabberVisible = false
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 12
        }
        present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        navigationItem.backButtonTitle = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
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
    
    
    // TODO: isLogIn에 맞게 분기 처리 필요.
    @objc func moveToProfile() {
        self.dismiss(animated: false)
        navigationController?.pushViewController(ProfileViewController(), animated: true)
        map.selectedAnnotations = []
        
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
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.0129, longitude: 129.3255), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)), animated: true)
        
        map.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)

        map.addSubview(mapButtons)
        mapButtons.anchor(top: map.topAnchor, right: map.rightAnchor, paddingTop: 50, paddingRight: 20, width: 40, height: 140)
        
        map.addSubview(compass)
        compass.anchor(top: map.topAnchor, left: map.leftAnchor, paddingTop: 50, paddingLeft: 20, width: 40, height: 40)
        
        map.addOverlay(circleOverlay)
        
        // TODO: - 비동기 처리로 수정
        map.addAnnotations(placeAnnotations)
        
        if userCheckedIn {
            view.addSubview(workingView)
            workingView.anchor(top: view.topAnchor, left: view.leftAnchor, right: mapButtons.leftAnchor, paddingTop: 50, paddingLeft: 50, paddingRight: 30, height: 44)
        }
        
        map.addSubview(listViewButton)
        listViewButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 15, paddingBottom: 70, width: 88, height: 43.73)
    }
    
    func registerAnnotationViewClasses() {
        map.register(CoworkingAnnotationView.self, forAnnotationViewWithReuseIdentifier: "dda")
        map.register(LibraryAnnotationView.self, forAnnotationViewWithReuseIdentifier: "dd")
        map.register(CafePlaceAnnotationView.self, forAnnotationViewWithReuseIdentifier: "cafeAnnotaion")
    }
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let view = view as? PlaceAnnotationView  {
            guard let annotation = view.annotation else { return }
            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - 0.004, longitude: annotation.coordinate.longitude ), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            let controller = PlaceInfoModalViewController()
            controller.selectedAnnotation = annotation
            controller.delegate = self
            present(controller, animated: true)
        } else {
            print("THIS is CLUSTER")
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.dismiss(animated: true)
    }
    
}

// MARK: - ClearSelectedAnnotation

extension MapViewController: ClearSelectedAnnotation {
    func clearAnnotation(view: MKAnnotation) {
        if view.isEqual(map.selectedAnnotations.first) {
            return
        }
        let tempAnnotations = map.selectedAnnotations
        map.selectedAnnotations = []
        for annotation in tempAnnotations {
            if !annotation.isEqual(view) {
                map.selectedAnnotations.append(annotation)
            }
        }
    }
}

// MARK: - SheetModalView in MapView

extension MapViewController: UISheetPresentationControllerDelegate {

}

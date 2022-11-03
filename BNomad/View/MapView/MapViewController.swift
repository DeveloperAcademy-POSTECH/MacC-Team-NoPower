//
//  MapViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit
import MapKit
import CoreLocation
import Combine

class MapViewController: UIViewController {
    
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    lazy var currentLocation: CLLocation? = locationManager.location
    let customStartLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 33.37, longitude: 126.53) // 디바이스 현재 위치 못 받을 경우 커스텀 시작 위치 정해야 함 (c5로? 제주로? 서울로? 전국 지도?) -> 우선은 제주도. 디바이스 위치 허용하면 제주도 볼 일 없음 ㅋㅋ
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared

    
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
    
    // TODO: - 회원가입, 로그인 화면 모두 넣어 연결하기
    @objc func moveToProfile() {
        self.dismiss(animated: false)
        /// 케이스 1 신규 유저 : 프로필 버튼 클릭 -> 로그인 화면 -> 가입 화면 -> 가입 후 로그인 -> 로그인 완료 -> 프로필 뷰
        /// 케이스 2 기존 유저 : 프로필 버튼 클릭 -> (비로그인 상태) -> 로그인 화면 -> 로그인 완료 -> 프로필 뷰
        /// 케이스 3 기존 유저 : 프로필 버튼 클릭 -> (로그인 상태) -> 프로필 뷰
        if viewModel.isLogIn {
            navigationController?.pushViewController(ProfileViewController(), animated: true)
        } else {
            let controller = SignUpViewController()
            controller.modalPresentationStyle = .fullScreen
            present(controller, animated: true)
        }
        map.selectedAnnotations = []
    }
    
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
        sheet.position = currentLocation
        sheet.delegateForFloating = self
        present(sheet, animated: true, completion: nil)
    }
    
    lazy var checkInNow: UIButton = {
        let button = UIButton()
        button.backgroundColor = CustomColor.nomadBlue
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius =  40 / 2
        button.setTitle("업무중", for: .normal)
        button.addTarget(self, action: #selector(goBackToCheckInView), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var store = Set<AnyCancellable>()
    
    // TODO: - 업무중 버튼 클릭 시 체크인 화면으로 돌아가야 하는데 오류 발생
    @objc func goBackToCheckInView() {
        let controller = PlaceCheckInViewController()
        guard let user = viewModel.user else { return print("USER ERR") }
        let tempPlace = self.viewModel.places.first { place in
            user.currentPlaceUid == place.placeUid
        }
        controller.selectedPlace = tempPlace
        controller.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true) {
            self.present(controller, animated: true)
        }
    }
    
    private var currentAnnotation: MKAnnotation?
    
    // MARK: - LifeCycle
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         navigationController?.navigationBar.isHidden = true
         navigationItem.backButtonTitle = ""
         checkInFloating()
         checkInBinding()
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        locationFuncs()
        configueMapUI()
        userCombine()
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    // 위치 권한 받아서 현재 위치 확인
    func locationFuncs() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
    }
    
    func setMapRegion(_ latitude: Double, _ longitude: Double, spanDelta: Double) {
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)), animated: true)
    }
    
    func checkInBinding() {
        print("체크인 바인딩 -> 위치 전달")
        if let user = viewModel.user {
            if user.isChecked {
                if let place = viewModel.places.first(where: { place in
                    place.placeUid == viewModel.user?.currentPlaceUid
                }) {
                    self.setMapRegion(place.latitude - 0.004, place.longitude, spanDelta: 0.01)
                    let annotation = MKAnnotationFromPlace.convertPlaceToAnnotation(place)
                    self.map.selectAnnotation(annotation, animated: true)
                    let controller = PlaceInfoModalViewController()
                    controller.selectedPlace = place
                    controller.delegateForClearAnnotation = self
                    controller.delegateForFloating = self
                    controller.presentationController?.delegate = self
                    present(controller, animated: true)
                }
                
                print("체크인 상태로 맵 세팅 끝")
            } else {
                if let location = currentLocation {
                    setMapRegion(location.coordinate.latitude, location.coordinate.longitude, spanDelta: 0.03)
                    print("체크아웃 상태 + 현재 위치 받아서 시작")
                } else {
                    setMapRegion(customStartLocation.latitude, customStartLocation.longitude, spanDelta: 0.05)
                    print("체크아웃 상태 + 현재 위치 확인 불가")
                }
            }
        } else {
            if let location = currentLocation {
                setMapRegion(location.coordinate.latitude, location.coordinate.longitude, spanDelta: 0.05)
                print("비로그인 상태 + 현재 위치 받아서 시작")
            } else {
                setMapRegion(customStartLocation.latitude, customStartLocation.longitude, spanDelta: 0.2)
                print("비로그인 상태 + 현재 위치 확인 불가")
            }
        }
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
        
        FirebaseManager.shared.fetchPlaceAll { place in
            self.map.addAnnotation(MKAnnotationFromPlace.convertPlaceToAnnotation(place))
            self.viewModel.places.append(place)
            self.checkInBinding()
        }
        
        map.addSubview(listViewButton)
        listViewButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 15, paddingBottom: 70, width: 88, height: 43.73)
    }

    
    func configureFloating() {
        view.addSubview(checkInNow)
        checkInNow.anchor(top: view.topAnchor, paddingTop: 60, width: 100, height: 40)
        checkInNow.centerX(inView: view)
    }
    
    func userCombine() {
        viewModel.$user
            .sink { user in
                guard let user = user else { return }
                self.checkInNow.isHidden = user.isChecked ? false : true
            }
            .store(in: &store)
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
        guard let annotation = annotation as? MKAnnotationFromPlace else { return nil }

        switch annotation.type {
        case .coworking:
            return CoworkingAnnotationView(annotation: annotation, reuseIdentifier: CoworkingAnnotationView.ReuseID)
        case .cafe:
            return CafePlaceAnnotationView(annotation: annotation, reuseIdentifier: CafePlaceAnnotationView.ReuseID)
        case .library:
            return LibraryAnnotationView(annotation: annotation, reuseIdentifier: LibraryAnnotationView.ReuseID)
        }
    }
    
//    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
//        if let annotation = annotation as? MKAnnotationFromPlace {
//            self.currentAnnotation = annotation
//            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - 0.004, longitude: annotation.coordinate.longitude ), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
//            let controller = PlaceInfoModalViewController()
//            let tempPlace = self.viewModel.places.first { place in
//                annotation.placeUid == place.placeUid
//            }
//            controller.selectedPlace = tempPlace
//            controller.delegateForClearAnnotation = self
//            controller.delegateForFloating = self
//            controller.presentationController?.delegate = self
//            present(controller, animated: true)
//            
//        } else {
//            print("THIS is CLUSTER")
//        }
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let view = view as? PlaceAnnotationView  {
            guard let annotation = view.annotation else { return }
            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - (0.003 / 0.01) * map.region.span.latitudeDelta, longitude: annotation.coordinate.longitude ), span: MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta, longitudeDelta: map.region.span.longitudeDelta)), animated: true)
            let controller = PlaceInfoModalViewController()
            let tempAnnotation = annotation as? MKAnnotationFromPlace
            let tempPlace = self.viewModel.places.first { place in
                tempAnnotation?.placeUid == place.placeUid
            }
            controller.selectedPlace = tempPlace
            controller.delegateForFloating = self
            controller.delegateForClearAnnotation = self
            present(controller, animated: true)
        } else {
            guard let annotation = view.annotation else { return }
            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude ), span: MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta / 4, longitudeDelta: map.region.span.longitudeDelta / 4)), animated: true)
            print("THIS is CLUSTER")
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.currentAnnotation = nil
        self.dismiss(animated: true)
    }
    
}

// MARK: - ClearSelectedAnnotation

extension MapViewController: ClearSelectedAnnotation {
    func clearAnnotation(view: MKAnnotation) {
//        if view.isEqual(map.selectedAnnotations.first) {
//            return
//        }
//        let tempAnnotations = map.selectedAnnotations
//        map.selectedAnnotations = []
//        for annotation in tempAnnotations {
//            if !annotation.isEqual(view) {
//                map.selectedAnnotations.append(annotation)
//            }
//        }
    }
}

// MARK: - UpdateFloating

extension MapViewController: UpdateFloating {
    func checkInFloating() {
        print("checkInFloating")
        guard let user = viewModel.user else { return }
        if user.isChecked {
            print("DUBG")
            checkInNow.isHidden = false
            map.addSubview(checkInNow)
            checkInNow.anchor(top: view.topAnchor, paddingTop: 60, width: 100, height: 40)
            checkInNow.centerX(inView: view)
        } else {
            checkInNow.isHidden = true
        }
    }
}

// MARK: - SheetModalView in MapView

extension MapViewController: UISheetPresentationControllerDelegate {
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("will dismiss")
        print("current map: \(self.map)")
        self.map.deselectAnnotation(self.currentAnnotation, animated: true)
    }
}


// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        map.removeOverlay(circleOverlay)
        map.addOverlay(circleOverlay)
    }
}

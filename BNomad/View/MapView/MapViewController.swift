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

protocol UpdateFloating {
    func checkInFloating()
}

protocol setMap {
    func setMapRegion(_ latitude: Double, _ longitude: Double, spanDelta: Double)
}

class MapViewController: UIViewController {
    
    // MARK: - Properties

    private let locationManager = CLLocationManager()
    lazy var currentLocation: CLLocation? = locationManager.location {
        didSet {
            map.addOverlay(circleOverlay)
        }
    }

    let customStartLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 33.37, longitude: 126.53) // 디바이스 현재 위치 못 받을 경우 커스텀 시작 위치 정해야 함 (c5로? 제주로? 서울로? 전국 지도?)
    
    private var currentAnnotation: MKAnnotation?
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    var store = Set<AnyCancellable>()
    
    var selectedRegion: Region?
    var visiblePlacesOnMap: [Place] = []
    var allAnnotation: [MKAnnotation] = []
    var visitedAnnotation: [MKAnnotation] = []
    var newAnnotation: [MKAnnotation] = []
    
    fileprivate let mapBtnBackgroundColor: UIColor = .white.withAlphaComponent(0.5)
    
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
        btn.anchor(width: 22, height: 22)
        btn.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        return btn
    }()
    
    func loginCheck() {
        print("loginCheck")
        let checkOutAlert = UIAlertController(title: "로그인하시겠습니까?", message: "로그인하시면 프로필을 보실 수 있습니다.", preferredStyle: .alert)
        checkOutAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        checkOutAlert.addAction(UIAlertAction(title: "로그인", style: .default, handler: { action in
            
            let controller = LoginViewController() // 추후 로그인뷰로 변경
            controller.delegate = self
//            controller.modalPresentationStyle = .fullScreen
            controller.sheetPresentationController?.detents = [.medium()]
            self.present(controller, animated: true)
        }))
        present(checkOutAlert, animated: true)
    }
    
    private let divider: UIButton = {
        let divider = UIButton()
        divider.setImage(UIImage(systemName: "squareshape.fill"), for: .normal)
        divider.isUserInteractionEnabled = false
        divider.anchor(width: 1.5, height: 24)
        return divider
    }()
    
    private lazy var settingBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "gearshape")?.withRenderingMode(.automatic), for: .normal)
        btn.anchor(width: 22, height: 22)
        btn.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
        return btn
    }()
    
    // 지역명 표기 및 지역 변경 버튼
    
    private let appTitle: UIButton = {
        var btn = UIButton()
        btn.setTitle("B.nomad ", for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.titleLabel?.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        btn.setTitleColor(.black, for: .normal)
        btn.tintColor = CustomColor.nomadBlue
//        btn.addTarget(self, action: #selector(presentRegionSelector), for: .touchUpInside) // 앱 네임을 눌렀을 때 pop-up이나 credit, contact 정보 뜨도록?
        return btn
    }()
    
    lazy var upperStack: UIStackView = {

        let topRightBtn = UIStackView(arrangedSubviews: [profileBtn, divider, settingBtn])
        topRightBtn.axis = .horizontal
        topRightBtn.alignment = .center
        topRightBtn.spacing = 5
        topRightBtn.tintColor = CustomColor.nomadBlue
        topRightBtn.distribution = .fillProportionally
        topRightBtn.anchor(width: 60)
        
        let upperStack = UIStackView(arrangedSubviews: [appTitle, topRightBtn])
        upperStack.axis = .horizontal
        upperStack.alignment = .fill
        upperStack.distribution = .equalSpacing
        return upperStack
    }()
    
    // 화면 상단 스택 백그라운드
    private let blurBackground: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let background = UIVisualEffectView(effect: blur)
        background.alpha = 0.7 // 기본 blur alpha 값 1.0 -> 0.7로 변경
        background.translatesAutoresizingMaskIntoConstraints = false
        return background
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
        button.backgroundColor = mapBtnBackgroundColor
        button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        button.tintColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 4
        button.layer.borderColor = CustomColor.nomadBlue?.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(presentPlaceListModal), for: .touchUpInside)
        return button
    }()
    
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
    
    @objc func goBackToCheckInView() {
        let controller = PlaceCheckInViewController()
        guard let user = viewModel.user else { return print("USER ERR") }
        let tempPlace = self.viewModel.places.first { place in
            user.currentPlaceUid == place.placeUid
        }
        controller.delegate = self
        controller.selectedPlace = tempPlace
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.tintColor = CustomColor.nomadBlue
        self.dismiss(animated: true) {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    private lazy var visitedPlaceMenu: UIButton = {
        
        let allPlaceAction = UIAction(title: "모든 스팟", handler: { _ in
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotations(self.allAnnotation)
        })
        
        let visitedPlaceAction = UIAction(title: "방문한 스팟", handler: { _ in
            self.map.removeAnnotations(self.map.annotations)
            self.visitedPlacesMapping()
            self.map.addAnnotations(self.visitedAnnotation)
        })
        
        let newPlaceAction = UIAction(title: "새로운 스팟", handler: { _ in
            self.map.removeAnnotations(self.map.annotations)
            self.visitedPlacesMapping()
            self.map.addAnnotations(self.newAnnotation)
        })
        
        allPlaceAction.state = .on // 기본적으로는 '모든 스팟'에 체크되어 있음
        
        let menu = UIMenu(title: "노마드 스팟 골라보기", options: .singleSelection, children: [allPlaceAction, visitedPlaceAction, newPlaceAction])
        
        let btn = UIButton()
        btn.showsMenuAsPrimaryAction = true
        btn.menu = menu
        btn.backgroundColor = mapBtnBackgroundColor
        btn.setImage(UIImage(systemName: "square.on.square"), for: .normal)
        btn.tintColor = CustomColor.nomadBlue
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = CustomColor.nomadBlue?.cgColor
        btn.layer.borderWidth = 1
        return btn
    }()
    
    lazy var regionSelectBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = mapBtnBackgroundColor
        btn.setImage(UIImage(systemName: "map"), for: .normal)
        btn.tintColor = CustomColor.nomadBlue
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = CustomColor.nomadBlue?.cgColor
        btn.layer.borderWidth = 1
        btn.anchor(width: 40, height: 40)
        btn.addTarget(self, action: #selector(presentRegionSelector), for: .touchUpInside)
        return btn
    }()
    
    lazy var userTrackingBtn: MKUserTrackingButton = {
        let btn = MKUserTrackingButton(mapView: map)
        btn.backgroundColor = mapBtnBackgroundColor
        btn.tintColor = CustomColor.nomadBlue
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = CustomColor.nomadBlue?.cgColor
        btn.layer.borderWidth = 1
        btn.anchor(width: 40, height: 40)
        return btn
    }()
    
    // MARK: - LifeCycle
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         navigationController?.navigationBar.isHidden = true
         navigationItem.backButtonTitle = ""
         checkInFloating()
         map.addOverlay(circleOverlay)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        locationFuncs()
        configueMapUI()
        checkInBinding()
        userCombine()
    }
    
    // MARK: - Actions
    
    @objc private func presentRegionSelector() {
        self.dismiss(animated: false)

        let sheet = RegionSelectViewController()
        sheet.modalPresentationStyle = .pageSheet
        if let sheet = sheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.delegate = self
            sheet.prefersGrabberVisible = false
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 12
        }
        sheet.regionChangeDelegate = self
        present(sheet, animated: true, completion: nil)
    }
    
    @objc private func presentPlaceListModal() {
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
        sheet.places = visiblePlacesOnMap
        sheet.position = currentLocation
        sheet.delegateForFloating = self
        present(sheet, animated: true, completion: nil)
    }
    
    // TODO: - 회원가입, 로그인 화면 모두 넣어 연결하기
    @objc func moveToProfile() {
        self.dismiss(animated: false)
        /// 케이스 1 신규 유저 : 프로필 버튼 클릭 -> 로그인 화면 -> 가입 화면 -> 가입 후 로그인 -> 로그인 완료 -> 프로필 뷰
        /// 케이스 2 기존 유저 : 프로필 버튼 클릭 -> (비로그인 상태) -> 로그인 화면 -> 로그인 완료 -> 프로필 뷰
        /// 케이스 3 기존 유저 : 프로필 버튼 클릭 -> (로그인 상태) -> 프로필 뷰
        if viewModel.isLogIn {
            let controller = ProfileViewController()
            controller.isMyProfile = true
            controller.nomad = viewModel.user
            navigationController?.pushViewController(controller, animated: true)
        } else {
            
            // TODO: - 회원가입 창 띄우기 전에 모달 띄우기
            loginCheck()
        }
        map.selectedAnnotations = []
    }
    
    @objc func goToSetting() {
        self.dismiss(animated: false)
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    // 방문했던/안했던 장소 분리하여 배열에 추가
    func visitedPlacesMapping() {
        self.visitedAnnotation.removeAll()
        self.newAnnotation.removeAll()
        
        for place in viewModel.places {
            guard let user = self.viewModel.user else { return }
            guard let history = user.checkInHistory else { return }
            
            if history.contains(where: { checkIn in
                checkIn.placeUid == place.placeUid
            }) {
                self.visitedAnnotation.append(MKAnnotationFromPlace.convertPlaceToAnnotation(place))
            } else {
                self.newAnnotation.append(MKAnnotationFromPlace.convertPlaceToAnnotation(place))
            }
        }
    }
    
    // MARK: - Helpers
    
    // 위치 권한 받아서 현재 위치 확인
    func locationFuncs() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
    }
    
    func checkInBinding() {
        print("체크인 바인딩 -> 위치 전달")
        if let user = viewModel.user {
            if user.isChecked {
                if let place = viewModel.places.first(where: { place in
                    place.placeUid == viewModel.user?.currentPlaceUid
                }) {
                    self.setMapRegion(place.latitude, place.longitude, spanDelta: 0.01)
//                    let annotation = MKAnnotationFromPlace.convertPlaceToAnnotation(place)
//                    self.map.selectAnnotation(annotation, animated: true)
//                    let controller = PlaceInfoModalViewController()
//                    controller.selectedPlace = place
//                    controller.delegateForFloating = self
//                    controller.presentationController?.delegate = self
//                    present(controller, animated: true)
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
//        if RCValue.shared.bool(forKey: ValueKey.isLoginFirst) && !viewModel.isLogIn {
//            let controller = SignUpViewController()
//            controller.modalPresentationStyle = .fullScreen
//            present(controller, animated: false)
//        }
        
        FirebaseManager.shared.fetchPlaceAll { place in
            self.map.addAnnotation(MKAnnotationFromPlace.convertPlaceToAnnotation(place))
            self.viewModel.places.append(place)
            self.checkInBinding()
            self.allAnnotation.append(MKAnnotationFromPlace.convertPlaceToAnnotation(place))
        }
        
        map.delegate = self
        
        view.addSubview(map)
        map.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        map.addSubview(blurBackground)
        blurBackground.anchor(top: map.topAnchor, left: map.leftAnchor, right: map.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 100)

        map.addSubview(upperStack)
        upperStack.anchor(top: map.topAnchor, left: map.leftAnchor, right: map.rightAnchor, paddingTop: 30, paddingLeft: 20, paddingRight: 20, height: 80)
        
        map.addSubview(compass)
        compass.anchor(top: map.topAnchor, left: map.leftAnchor, paddingTop: 110, paddingLeft: 15, width: 40, height: 40)

        map.addSubview(visitedPlaceMenu)
        visitedPlaceMenu.anchor(left: map.leftAnchor, bottom: map.bottomAnchor, paddingLeft: 15, paddingBottom: 115, width: 40, height: 40)
       
        map.addSubview(listViewButton)
        listViewButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 15, paddingBottom: 70, width: 40, height: 40)
        
        map.addSubview(regionSelectBtn)
        regionSelectBtn.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 115, paddingRight: 15, width: 40, height: 85)
        
        map.addSubview(userTrackingBtn)
        userTrackingBtn.anchor(bottom: view.bottomAnchor, right: view.rightAnchor, paddingBottom: 70, paddingRight: 15, width: 40, height: 85)
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

    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let userAnnotationView = mapView.view(for: mapView.userLocation)
        userAnnotationView?.isUserInteractionEnabled = false
        userAnnotationView?.canShowCallout = false
        userAnnotationView?.isEnabled = false
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        visiblePlacesOnMap = []
        
        for place in viewModel.places {
            if mapView.visibleMapRect.contains(MKMapPoint(CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)))
            {
                visiblePlacesOnMap.append(place)
            } else {
                visiblePlacesOnMap.removeAll { $0.name == place.name }
            }
        }
    }
    
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let view = view as? PlaceAnnotationView  {
            guard let annotation = view.annotation else { return }
            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - (0.002 / 0.01) * map.region.span.latitudeDelta, longitude: annotation.coordinate.longitude ), span: MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta, longitudeDelta: map.region.span.longitudeDelta)), animated: true)
            let controller = PlaceInfoModalViewController()
            let tempAnnotation = annotation as? MKAnnotationFromPlace
            let tempPlace = self.viewModel.places.first { place in
                tempAnnotation?.placeUid == place.placeUid
            }
            controller.selectedPlace = tempPlace
            controller.delegateForFloating = self
            present(controller, animated: true)
        } else {
            guard let annotation = view.annotation else { return }
            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude ), span: MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta / 5, longitudeDelta: map.region.span.longitudeDelta / 5)), animated: true)
            print("THIS is CLUSTER")
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.currentAnnotation = nil
        self.dismiss(animated: true)
    }
    
}

// MARK: - UpdateFloating

extension MapViewController: UpdateFloating {
    func checkInFloating() {
        map.addSubview(checkInNow)
        checkInNow.anchor(top: view.topAnchor, paddingTop: 110, width: 100, height: 40)
        checkInNow.centerX(inView: view)
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

// MARK: - MapRegionChange

extension MapViewController: setMap {
    func setMapRegion(_ latitude: Double, _ longitude: Double, spanDelta: Double) {
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: spanDelta)), animated: true)
    }
}

// MARK: - ReviewPage

extension MapViewController: ReviewPage {
    func reviewPageShow(place: Place) {
        // TODO: PlaceInfoModalViweController가 띄워져 있으면 Review 모달이 안뜨는 오류가 있음
        self.dismiss(animated: true)
        let controller = ReviewDetailViewController()
        controller.place = place
        controller.sheetPresentationController?.detents = [.large()]
        self.present(controller, animated: true)
    }
}

// MARK: - LogInToSignUp

extension MapViewController: LogInToSignUp {
    func logInToSignUp(userIdentifier: String) {
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .fullScreen
        signUpViewController.userIdentifier = userIdentifier
        self.present(signUpViewController, animated: true)
    }
}

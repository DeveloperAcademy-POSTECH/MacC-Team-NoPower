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
      
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    var store = Set<AnyCancellable>()
    
    var selectedRegion: Region?
    var visiblePlacesOnMap: [Place] = []
    var allAnnotation: [MKAnnotation] = []
    var visitedAnnotation: [MKAnnotation] = []
    var newAnnotation: [MKAnnotation] = []
    var checkedPlaceName: String?
    var checkedTime: String?
    var places: [Place] = []
    
    fileprivate let mapBtnBackgroundColor: UIColor = .white.withAlphaComponent(0.85)
    
    // 맵 띄우기
    lazy var map: MKMapView = {
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
        btn.setImage(UIImage(systemName: "person.fill"), for: .normal)
        btn.anchor(width: 22, height: 22)
        btn.addTarget(self, action: #selector(moveToProfile), for: .touchUpInside)
        btn.tintAdjustmentMode = .normal
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
        divider.tintAdjustmentMode = .normal
        return divider
    }()
    
    private lazy var settingBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "gearshape.fill")?.withRenderingMode(.automatic), for: .normal)
        btn.anchor(width: 22, height: 22)
        btn.addTarget(self, action: #selector(goToSetting), for: .touchUpInside)
        btn.tintAdjustmentMode = .normal
        return btn
    }()
    
    private let appTitle: UIButton = {
        var btn = UIButton()
        btn.setTitle("B.nomad ", for: .normal)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.titleLabel?.font = .preferredFont(forTextStyle: .headline, weight: .semibold)
        btn.setTitleColor(.black, for: .normal)
//        btn.addTarget(self, action: #selector(presentRegionSelector), for: .touchUpInside) // 앱 네임을 눌렀을 때 pop-up이나 credit, contact 정보 뜨도록?
        return btn
    }()
    
    lazy var upperStack: UIStackView = {

        let topRightBtn = UIStackView(arrangedSubviews: [profileBtn, divider, settingBtn])
        topRightBtn.axis = .horizontal
        topRightBtn.alignment = .center
        topRightBtn.spacing = 5
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
        background.alpha = 0.6 // 기본 blur alpha 값 1.0 -> 0.6으로 변경
        return background
    }()
    
    private let colorFilter: UIView = {
        let view = UIView()
        return view
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
        button.tintAdjustmentMode = .normal
        return button
    }()
    
    lazy var checkInNow: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white.withAlphaComponent(0.85)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.15
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowRadius = 5
        button.setTitleColor(CustomColor.nomadBlue, for: .normal)
        button.tintColor = CustomColor.nomadBlue
        button.tintAdjustmentMode = .normal
        button.addTarget(self, action: #selector(goBackToCheckInView), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var visitedPlaceMenu: UIButton = {
        
        let allPlaceAction = UIAction(title: "모든 스팟", handler: { _ in
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotations(self.allAnnotation)
            self.visitedPlaceMenu.setImage(UIImage(systemName: "pin"), for: .normal)
        })
        
        let visitedPlaceAction = UIAction(title: "방문한 스팟", handler: { _ in
            self.map.removeAnnotations(self.map.annotations)
            self.visitedPlacesMapping()
            self.map.addAnnotations(self.visitedAnnotation)
            self.visitedPlaceMenu.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        })
        
        let newPlaceAction = UIAction(title: "새로운 스팟", handler: { _ in
            self.map.removeAnnotations(self.map.annotations)
            self.visitedPlacesMapping()
            self.map.addAnnotations(self.newAnnotation)
            self.visitedPlaceMenu.setImage(UIImage(systemName: "pin.fill"), for: .normal)
        })
        
        allPlaceAction.state = .on // 기본적으로는 '모든 스팟'에 체크되어 있음
        
        let menu = UIMenu(title: "노마드 스팟 골라보기", options: .singleSelection, children: [allPlaceAction, visitedPlaceAction, newPlaceAction])
        
        let btn = UIButton()
        btn.showsMenuAsPrimaryAction = true
        btn.menu = menu
        btn.backgroundColor = mapBtnBackgroundColor
        btn.setImage(UIImage(systemName: "pin"), for: .normal)
        btn.tintColor = CustomColor.nomadBlue
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = CustomColor.nomadBlue?.cgColor
        btn.layer.borderWidth = 1
        btn.tintAdjustmentMode = .normal
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
        btn.tintAdjustmentMode = .normal
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
        btn.tintAdjustmentMode = .normal
        return btn
    }()
    
    // MARK: - LifeCycle
    
     override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
         navigationItem.backButtonTitle = ""
         checkInFloating()
         map.addOverlay(circleOverlay)
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        locationFuncs()
        configueMapUI()
        bindingPlaceLocationStatus()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        self.dismiss(animated: false)
        let sheet = PlaceListViewController()
        sheet.modalPresentationStyle = .pageSheet
        if let sheet = sheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.delegate = self
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 12
            sheet.prefersGrabberVisible = true
        }
        sheet.places = visiblePlacesOnMap
        sheet.position = currentLocation
        sheet.delegateForFloating = self
        sheet.regionChangeDelegate = self
        present(sheet, animated: true, completion: nil)
    }
    
    // TODO: - 회원가입, 로그인 화면 모두 넣어 연결하기
    @objc func moveToProfile() {
        self.dismiss(animated: false)
        /// 케이스 1 신규 유저 : 프로필 버튼 클릭 -> 로그인 화면 -> 가입 화면 -> 가입 후 로그인 -> 로그인 완료 -> 프로필 뷰
        /// 케이스 2 기존 유저 : 프로필 버튼 클릭 -> (비로그인 상태) -> 로그인 화면 -> 로그인 완료 -> 프로필 뷰
        /// 케이스 3 기존 유저 : 프로필 버튼 클릭 -> (로그인 상태) -> 프로필 뷰
        if viewModel.user != nil {
            let controller = ProfileViewController()
            controller.isMyProfile = true
            controller.nomad = viewModel.user
            navigationController?.pushViewController(controller, animated: true)
        } else {
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
    
    func checkedPlaceNameBinding() {
        guard let user = viewModel.user else { return }
        let checkedPlace = self.viewModel.places.first { place in
            place.placeUid == user.currentPlaceUid
        }
        
        self.checkedPlaceName = checkedPlace?.name
        self.checkedTime = user.currentCheckIn?.checkInTime.toTimeString()
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(CustomColor.nomadBlue ?? .black)
        
        // title
        let fullText = NSMutableAttributedString()
        fullText.append(NSAttributedString(attachment: imageAttachment))
        fullText.append(NSAttributedString(string: "\(checkedPlaceName ?? "")"))
        
        // subtitle
        var config = UIButton.Configuration.plain()
        config.attributedSubtitle = AttributedString(NSAttributedString(string: "\(checkedTime ?? "")부터 열일중", attributes: [.foregroundColor: CustomColor.nomadGray1 as Any, .font: UIFont.preferredFont(forTextStyle: .caption2)]))
        config.titleAlignment = .center
        
        checkInNow.configuration = config
        checkInNow.setAttributedTitle(fullText, for: .normal)
    }
    
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
    
    // MARK: - Helpers
    
    // 위치 권한 받아서 현재 위치 확인
    func locationFuncs() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    private func bindingPlaceLocationStatus() {
        Task {
            places = []
            await fetchPlaces()
            await MainActor.run(body: {
                places.forEach { [weak self] place in
                    guard let self = self else { return }
                    self.map.addAnnotation(MKAnnotationFromPlace.convertPlaceToAnnotation(place))
                    self.viewModel.places.append(place)
                    self.allAnnotation.append(MKAnnotationFromPlace.convertPlaceToAnnotation(place))
                }
                self.checkInLocationBinding()
                self.checkedPlaceNameBinding()
                userCombine()
            })
        }
    }
    
    private func fetchPlaces() async {
        await FirebaseManager.shared.fetchPlaceAll { place in
            self.places.append(place)
        }
    }
    
    func checkInLocationBinding() {
        print("체크인 바인딩 -> 위치 전달")
        if let user = viewModel.user {
            if user.isChecked {
                if let place = viewModel.places.first(where: { place in
                    place.placeUid == viewModel.user?.currentPlaceUid
                }) {
                    self.setMapRegion(place.latitude, place.longitude, spanDelta: 0.01)
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
        
        map.addSubview(blurBackground)
        blurBackground.anchor(top: map.topAnchor, left: map.leftAnchor, right: map.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 100)
        
        map.addSubview(colorFilter)
        colorFilter.anchor(top: map.topAnchor, left: map.leftAnchor, right: map.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 100)

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
                guard let user = user else {
                    self.checkInNow.isHidden = true
                    self.colorFilter.backgroundColor = .white.withAlphaComponent(0.1)
                    self.appTitle.setTitleColor(.black, for: .normal)
                    self.upperStack.tintColor = CustomColor.nomadBlue
                    return
                }
                
                if user.isChecked {
                    self.checkInNow.isHidden = false
                    self.colorFilter.backgroundColor = CustomColor.nomadBlue?.withAlphaComponent(0.8)
                    self.appTitle.setTitleColor(.white, for: .normal)
                    self.upperStack.tintColor = .white
                } else {
                    self.checkInNow.isHidden = true
                    self.colorFilter.backgroundColor = .white.withAlphaComponent(0.1)
                    self.appTitle.setTitleColor(.black, for: .normal)
                    self.upperStack.tintColor = CustomColor.nomadBlue
                }
                
                self.checkedPlaceNameBinding()
            }
            .store(in: &store)
    }
    
    func locationCheck(){
        let status = CLLocationManager().authorizationStatus

        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
            let alter = UIAlertController(title: "위치 접근 허용 설정이 제한되어 있습니다.", message: "해당 장소의 장소보기 및 체크인 기능을 사용하려면 위치 접근을 허용해주셔야 합니다. 앱 설정 화면으로 가시겠습니까?", preferredStyle: UIAlertController.Style.alert)
            let logOkAction = UIAlertAction(title: "설정", style: UIAlertAction.Style.default){
                (action: UIAlertAction) in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                }
            }
            let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive)
            alter.addAction(logNoAction)
            alter.addAction(logOkAction)
            self.present(alter, animated: true, completion: nil)
        }
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
        
        let latitude: Double = currentLocation?.coordinate.latitude ?? 0.0
        let longitude: Double = currentLocation?.coordinate.longitude ?? 0.0
        visiblePlacesOnMap = visiblePlacesOnMap.sorted { Contents.calculateDistance(userLatitude: latitude, placeLatitude: $0.latitude, userLongitude: longitude, placeLongitude: $0.longitude) < Contents.calculateDistance(userLatitude: latitude, placeLatitude: $1.latitude, userLongitude: longitude, placeLongitude: $1.longitude) }
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
        self.dismiss(animated: true)

        if let view = view as? PlaceAnnotationView  {
            guard let annotation = view.annotation else { return }
            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude - (0.002 / 0.01) * map.region.span.latitudeDelta, longitude: annotation.coordinate.longitude ), span: MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta, longitudeDelta: map.region.span.longitudeDelta)), animated: true)
            let tempAnnotation = annotation as? MKAnnotationFromPlace
            let tempPlace = self.viewModel.places.first { place in
                tempAnnotation?.placeUid == place.placeUid
            }
            
            let controller = PlaceInfoModalViewController()
            controller.selectedPlace = tempPlace
            controller.delegateForFloating = self
            present(UINavigationController(rootViewController: controller), animated: true)
        } else {
            guard let annotation = view.annotation else { return }
            map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude ), span: MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta / 5, longitudeDelta: map.region.span.longitudeDelta / 5)), animated: true)
            print("THIS is CLUSTER")
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.dismiss(animated: false)
        
        map.becomeFirstResponder()

    }
    
}

// MARK: - UpdateFloating

extension MapViewController: UpdateFloating {
    func checkInFloating() {
        map.addSubview(checkInNow)
        checkInNow.anchor(top: view.topAnchor, paddingTop: 110, width: 250, height: 50)
        checkInNow.centerX(inView: view)
        checkedPlaceNameBinding()
    }
}

// MARK: - SheetModalView in MapView

extension MapViewController: UISheetPresentationControllerDelegate {
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("will dismiss")
        
        self.dismiss(animated: false)
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

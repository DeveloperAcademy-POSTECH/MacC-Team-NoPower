//
//  PlaceInfoModalViewController.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/20.
//

import UIKit
import MapKit



class PlaceInfoModalViewController: UIViewController {
    
    // MARK: - Properties
    var selectedPlace: Place? {
        didSet {
            guard let selectedPlace = selectedPlace else { return }
            FirebaseManager.shared.fetchCheckInHistory(placeUid: selectedPlace.placeUid) { checkInHistory in
                let history = checkInHistory.filter { $0.checkOutTime == nil }
                self.checkInHistory = history
            }
        }
    }
        
    let locationManager = CLLocationManager()
    lazy var currentLocation = locationManager.location
    
    var delegateForClearAnnotation: ClearSelectedAnnotation?
    var delegateForFloating: UpdateFloating?
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    
    let placeInfoCollectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let placeInfoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        return placeInfoCollectionView
    }()
    
    var checkInHistory: [CheckIn]? {
        didSet {
            guard let checkInHistory = checkInHistory else { return }
            numberOfUsers = checkInHistory.count
            placeInfoCollectionView.reloadData()
        }
    }
    
    private var numberOfUsers: Int = 0


    // TODO: - checkIn, checkOut 버튼 하나로 통일 후 user.isChecked 기반으로 버튼 상태 변경
    lazy var checkInButton: UIButton = {
        var button = UIButton()
        button.setTitle("체크인 하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
        
        return button
    }()
    
    lazy var checkOutButton: UIButton = {
        var button = UIButton()
        button.setTitle("체크아웃 하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadGray1
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(checkOut), for: .touchUpInside)

        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCheckInButton()
        setupSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let selectedPlace = selectedPlace else { return }
        delegateForClearAnnotation?.clearAnnotation(view: MKAnnotationFromPlace.convertPlaceToAnnotation(selectedPlace))
    }
    
    // MARK: - Actions
    
    @objc func checkOut() {
        print("CHECK OUT")
        let checkOutAlert = UIAlertController(title: "체크아웃", message: "체크아웃하시겠습니까?", preferredStyle: .alert)
        checkOutAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        checkOutAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
            guard
                var checkIn = self.viewModel.user?.currentCheckIn
            else {
                print("checkIn 이력이 없습니다.")
                return
            }
            checkIn.checkOutTime = Date()
            FirebaseManager.shared.setCheckOut(checkIn: checkIn) { checkIn in
                
                
                let index = self.viewModel.user?.checkInHistory?.firstIndex { $0.checkInUid == checkIn.checkInUid }
                guard let index = index else {
                    print("fail index")
                    return
                }
                self.viewModel.user?.checkInHistory?[index] = checkIn
                
                print("checkOut 완료")
                print(checkIn)
                print(self.viewModel.user?.isChecked)
                print(self.viewModel.user?.currentPlaceUid)
                guard let user = self.viewModel.user else { return }
                if user.isChecked && self.selectedPlace?.placeUid == user.checkInHistory?.last?.placeUid {
                    self.checkInButton.isHidden = true
                    self.checkOutButton.isHidden = false
                } else if user.isChecked && self.selectedPlace?.placeUid != user.checkInHistory?.last?.placeUid {
                    self.checkInButton.isHidden = true
                    self.checkOutButton.isHidden = true
                } else {
                    self.checkInButton.isHidden = false
                    self.checkOutButton.isHidden = true
                }
                
                self.delegateForFloating?.checkInFloating()
            }

        }))
        present(checkOutAlert, animated: true)
    }
    
    @objc func checkIn() {
        print("CHECK IN")        
        if !viewModel.isLogIn {
            loginCheck()
        } else {
            distanceChecker()
        }
    }
    
    func loginCheck() {
        print("loginCheck")
        let checkOutAlert = UIAlertController(title: "로그인하시겠습니까?", message: "로그인하시면 체크인하실 수 있습니다.", preferredStyle: .alert)
        checkOutAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        checkOutAlert.addAction(UIAlertAction(title: "로그인", style: .default, handler: { action in
            let controller = SignUpViewController() // 추후 로그인뷰로 변경
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true)
        }))
        present(checkOutAlert, animated: true)
    }
    
    func distanceChecker() {
        let boundary = CLCircularRegion(center: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: 1000, identifier: "반경 500m")
        

              // TODO: - 하드 코딩된 부분 변경 -> "노마드 제주에 체크인 하시겠습니까?" ---- 완료

        guard let selectedPlace = selectedPlace else { return }
        if boundary.contains(CLLocationCoordinate2D(latitude: selectedPlace.latitude, longitude: selectedPlace.longitude)) {
            let checkInAlert = UIAlertController(title: "체크인 하시겠습니까?", message: "\(selectedPlace.name)에 체크인합니다.", preferredStyle: .alert)

            checkInAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            checkInAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                // TODO: Firebase에 올리는 작업, checkInButton 색 바로 업데이트 해야함
                // TODO: mapView 상단 체크인하고 있다는 배너 업테이트 해주어야함
                // TODO: - isChecked 직접적으로 수정하지 않기 & Firebase에 체크인 정보 업데이트, FirebaseTestVC의 setCheckIn() 참고
                
                guard let userUid = self.viewModel.user?.userUid else { return }
                
                let checkIn = CheckIn(userUid: userUid , placeUid: selectedPlace.placeUid, checkInUid: UUID().uuidString, checkInTime: Date())
                FirebaseManager.shared.setCheckIn(checkIn: checkIn) { checkIn in
                    if self.viewModel.user?.checkInHistory == nil {
                        self.viewModel.user?.checkInHistory = [checkIn]
                    } else {
                        self.viewModel.user?.checkInHistory?.append(checkIn)
                    }
                    self.delegateForFloating?.checkInFloating()
                    print("checkin 성공 여부", self.viewModel.user?.isChecked)
                    print("checkin한 장소", self.viewModel.user?.currentPlaceUid)
                }
                self.delegateForFloating?.checkInFloating()
                let controller = PlaceCheckInViewController()
                controller.selectedPlace = selectedPlace
                controller.modalPresentationStyle = .fullScreen
                self.present(controller, animated: true)
            }))
            present(checkInAlert, animated: true)
        } else {
            let distanceAlert = UIAlertController(title: "체크인 불가", message: "해당 장소에 500미터 이내로 접근하시면 체크인이 가능합니다.", preferredStyle: .alert)
            distanceAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
            present(distanceAlert, animated: true)
        }

    }
    
    // MARK: - Helpers
    
    func checkButton() {
        guard let user = viewModel.user else { return }
        if user.isChecked && selectedPlace?.placeUid == user.currentCheckIn?.placeUid {
            checkInButton.isHidden = true
            checkOutButton.isHidden = false
        } else if user.isChecked && selectedPlace?.placeUid != user.currentCheckIn?.placeUid {
            checkInButton.isHidden = true
            checkOutButton.isHidden = true
        } else {
            checkInButton.isHidden = false
            checkOutButton.isHidden = true
        }
    }
    
    func configureCollectionView() {
        placeInfoCollectionView.dataSource = self
        placeInfoCollectionView.delegate = self
        placeInfoCollectionView.backgroundColor = .white
        placeInfoCollectionView.register(PlaceInfoCell.self, forCellWithReuseIdentifier: PlaceInfoCell.cellIdentifier)
        placeInfoCollectionView.register(ReviewInfoCell.self, forCellWithReuseIdentifier: ReviewInfoCell.cellIdentifier)
        placeInfoCollectionView.register(WithNomadHeader.self, forCellWithReuseIdentifier: WithNomadHeader.identifier)
        placeInfoCollectionView.register(CheckedProfileListViewCell.self, forCellWithReuseIdentifier: CheckedProfileListViewCell.identifier)
        view.addSubview(placeInfoCollectionView)
        placeInfoCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func configureCheckInButton() {
        view.addSubview(checkOutButton)
        checkOutButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 17, paddingBottom: 50, paddingRight: 17, height: 50)
        
        view.addSubview(checkInButton)
        checkInButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 17, paddingBottom: 50, paddingRight: 17, height: 50)
    }
    
    private func setupSheet() {
//        밑으로 내려도 dismiss되지 않는 옵션 값
//          isModalInPresentation = true

        if let sheet = sheetPresentationController {
            /// 드래그를 멈추면 그 위치에 멈추는 지점: default는 large()
            sheet.detents = [.medium(), .large()]
            /// 초기화 드래그 위치
            sheet.selectedDetentIdentifier = .medium
            /// sheet아래에 위치하는 ViewController를 흐려지지 않게 하는 경계값 (medium 이상부터 흐려지도록 설정)
            sheet.largestUndimmedDetentIdentifier = .medium
            /// false는 viewController내부를 scroll하면 sheet가 움직이지 않고 내부 컨텐츠를 스크롤되도록 설정
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 12
        }
    }
    

}

// MARK: - UICollectionViewDataSource

extension PlaceInfoModalViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3 {
            return self.checkInHistory?.count ?? 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceInfoCell.cellIdentifier, for: indexPath) as? PlaceInfoCell else { return UICollectionViewCell() }
            cell.position = currentLocation
            cell.place = selectedPlace
            
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewInfoCell.cellIdentifier, for: indexPath) as? ReviewInfoCell else { return UICollectionViewCell() }
            return cell
        }
        else if indexPath.section == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WithNomadHeader.identifier, for: indexPath) as? WithNomadHeader else { return UICollectionViewCell() }
            cell.numberOfUsers = numberOfUsers
           
            return cell
        }
        else if indexPath.section == 3 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListViewCell.identifier, for: indexPath) as? CheckedProfileListViewCell else { return UICollectionViewCell() }
            
            guard let checkIn = checkInHistory else { return UICollectionViewCell() }
            let userUids = checkIn.compactMap {$0.userUid}
            cell.userUid = userUids[indexPath.row]
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
}



// MARK: - UICollectionViewDelegate

extension PlaceInfoModalViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaceInfoModalViewController: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flow = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize()
        }
        
        let viewWidth = view.bounds.width
        let sectionZeroCardHeight: CGFloat = 266
        let sectionZeroBottomPadding: CGFloat = 25
        let sectionZeroHeight = sectionZeroCardHeight + sectionZeroBottomPadding
        
        if indexPath.section == 0 {
            return CGSize(width: viewWidth, height: 400)
        } else if indexPath.section == 1 {
            return CGSize(width: viewWidth, height: 370)
        } else if indexPath.section == 2 {
            return CGSize(width: viewWidth, height: 27)
        } else if indexPath.section == 3 {
            flow.sectionInset.top = 13
            
            return CGSize(width: 349, height: 68)
        } else {
            return CGSize(width: viewWidth, height: 0)
        }
    }
    
    // 셀 크기 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

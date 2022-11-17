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
            FirebaseManager.shared.fetchReviewHistory(placeUid: selectedPlace.placeUid) { reviewHistory in
                self.reviewHistory = reviewHistory
            }
        }
    }

    let locationManager = CLLocationManager()
    lazy var currentLocation = locationManager.location
    
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
    
    var reviewHistory: [Review]? {
        didSet {
            guard let reviewHistory = reviewHistory else { return }
            placeInfoCollectionView.reloadData()
        }
    }
    
    private var numberOfUsers: Int = 0
    
    var checkInAlert: UIAlertController = {
        let alert = UIAlertController(title: "체크인 하시겠습니까?", message: "", preferredStyle: .alert)
        return alert
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupSheet()
    }
    
    // MARK: - Helpers
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 키보드 업데이트 시 원하는 기능
        if textField.hasText {
            checkInAlert.actions[1].isEnabled = true
        } else {
            checkInAlert.actions[1].isEnabled = false
        }
    }
    
    func checkIn() {
        print("CHECK IN")
        if !viewModel.isLogIn {
            loginCheck()
        } else {
            if distanceChecker() {
                guard let selectedPlace = selectedPlace else { return }

                let checkInAlert = checkInAlert
                checkInAlert.message = "\(selectedPlace.name)에 체크인합니다."
                
                checkInAlert.addTextField() { textField in
                    textField.placeholder = "오늘의 목표를 입력해주세요"
                    textField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
                }
                
                checkInAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
                
                checkInAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                    // TODO: Firebase에 올리는 작업, checkInButton 색 바로 업데이트 해야함
                    // TODO: mapView 상단 체크인하고 있다는 배너 업테이트 해주어야함
                    // TODO: - isChecked 직접적으로 수정하지 않기 & Firebase에 체크인 정보 업데이트, FirebaseTestVC의 setCheckIn() 참고
                    
                    self.checkInFirebase()
                    self.delegateForFloating?.checkInFloating()
                    self.presentPlaceCheckInView()
                    
                    print(checkInAlert.textFields?[0].text) //추후 체크인 메시지 모델로 연결
                }))
                
                checkInAlert.actions[1].isEnabled = false

                present(checkInAlert, animated: true)
            } else {
                let distanceAlert = UIAlertController(title: "체크인 불가", message: "해당 장소에 500미터 이내로 접근하시면 체크인이 가능합니다.", preferredStyle: .alert)
                distanceAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
                present(distanceAlert, animated: true)
            }
        }
    }
    
    func presentPlaceCheckInView() {
        guard let selectedPlace = selectedPlace else { return }

        let controller = PlaceCheckInViewController()
        controller.selectedPlace = selectedPlace
        controller.delegate = self
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationItem.title = selectedPlace.name
        navigationController.navigationBar.tintColor = CustomColor.nomadBlue
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func checkInFirebase() {
        guard let selectedPlace = selectedPlace else { return }
        guard let userUid = self.viewModel.user?.userUid else { return }

        let checkIn = CheckIn(userUid: userUid , placeUid: selectedPlace.placeUid, checkInUid: UUID().uuidString, checkInTime: Date())
        FirebaseManager.shared.setCheckIn(checkIn: checkIn) { checkIn in
            if self.viewModel.user?.checkInHistory == nil {
                self.viewModel.user?.checkInHistory = [checkIn]
            } else {
                self.viewModel.user?.checkInHistory?.append(checkIn)
            }
            self.delegateForFloating?.checkInFloating()
        }
    }
    
    func checkOut() {
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
                self.delegateForFloating?.checkInFloating()
                self.present(ReviewDetailViewController(), animated: true)
            }
        }))
        present(checkOutAlert, animated: true)
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
    
    func loginCheck() {
        print("loginCheck")
        let checkOutAlert = UIAlertController(title: "로그인하시겠습니까?", message: "로그인하시면 체크인하실 수 있습니다.", preferredStyle: .alert)
        checkOutAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        checkOutAlert.addAction(UIAlertAction(title: "로그인", style: .default, handler: { action in
            let controller = LoginViewController()
            controller.delegate = self
            controller.sheetPresentationController?.detents = [.medium()]
            self.present(controller, animated: true)
        }))
        present(checkOutAlert, animated: true)
    }
    
    func distanceChecker() -> Bool {
        let boundary = CLCircularRegion(center: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: 1000, identifier: "반경 500m")
        guard let selectedPlace = selectedPlace else { return false }
        if boundary.contains(CLLocationCoordinate2D(latitude: selectedPlace.latitude, longitude: selectedPlace.longitude)) {
            return true
        } else {
            return false
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
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewInfoCell.cellIdentifier, for: indexPath) as? ReviewInfoCell else { return UICollectionViewCell() }
            cell.reviewHistory = reviewHistory
            cell.delegate = self
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
            return CGSize(width: viewWidth, height: 350)
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

// MARK: - CheckInOut

extension PlaceInfoModalViewController: CheckInOut {
    func checkInTapped() {
        checkIn()
    }
    
    func checkOutTapped() {
        checkOut()
    }
}

// MARK: - ReviewPage

extension PlaceInfoModalViewController: ReviewPage {
    func reviewPageShow(place: Place) {
        self.dismiss(animated: false)
        let controller = ReviewDetailViewController()
        controller.place = place
        controller.sheetPresentationController?.detents = [.large()]
        self.present(controller, animated: true)
    }
}

extension PlaceInfoModalViewController: LogInToSignUp {
    func logInToSignUp(userIdentifier: String) {
        let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .fullScreen
        signUpViewController.userIdentifier = userIdentifier
        self.present(signUpViewController, animated: true)
    }
}

// MARK: - ShowReviewListView
extension PlaceInfoModalViewController: ShowReviewListView {
    func didTapShowReviewListView() {
        let ReviewListView = ReviewListViewController()
        self.present(ReviewListView, animated: true, completion: nil)
    }
}

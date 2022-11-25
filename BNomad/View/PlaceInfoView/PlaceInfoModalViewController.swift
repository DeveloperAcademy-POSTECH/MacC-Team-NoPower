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
    var reviewHistoryUid: String?
    
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
            guard reviewHistory != nil else { return }
            placeInfoCollectionView.reloadData()
//            setupSheet()
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
        locationCheck()
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
                    
                    self.checkInFirebase()
                    self.delegateForFloating?.checkInFloating()
                    self.presentPlaceCheckInView()
                    
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

        let checkIn = CheckIn(userUid: userUid , placeUid: selectedPlace.placeUid, checkInUid: UUID().uuidString, checkInTime: Date(), todayGoal: checkInAlert.textFields?[0].text)
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
        if let sheet = sheetPresentationController {
//            sheet.detents = reviewHistory?.count == 0 ? [.medium()] : [.medium(), .large()]
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.preferredCornerRadius = 12
            sheet.prefersGrabberVisible = true
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

// MARK: - UICollectionViewDataSource

extension PlaceInfoModalViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 3 {
            return self.checkInHistory?.count ?? 0
        } else if section == 1 {
            return self.reviewHistory?.count == 0 ? 0 : 1
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
            cell.todayGoal = checkIn[indexPath.row].todayGoal
            
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
        let width = collectionView.frame.width
        if indexPath.section == 0 {
            return CGSize(width: viewWidth, height: 350)
        } else if indexPath.section == 1 {
            let maxSize = CGSize(width: viewWidth, height: 400)
            let finalSize = CGSize(width: viewWidth, height: 100 + CGFloat((reviewHistory?.count ?? 1) * 80))
            if finalSize.height > maxSize.height {
                return maxSize
            } else {
                return finalSize
            }
        } else if indexPath.section == 2 {
            return CGSize(width: viewWidth, height: 40)
        } else if indexPath.section == 3 {
            flow.sectionInset.top = 13
            return CGSize(width: width - 30, height: 68)
        } else {
            return CGSize(width: viewWidth, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let controller = PlaceInfoModalViewController()
            controller.reviewHistoryUid = reviewHistory?[indexPath.row].userUid
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // 셀 크기 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 10, bottom: 0, right: 10)
    }
    
}

// MARK: - CheckInOut

extension PlaceInfoModalViewController: CheckInOut {
    func afterCheckInTapped() {
        let controller = PlaceCheckInViewController()
        controller.delegate = self
        controller.selectedPlace = selectedPlace
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.navigationBar.tintColor = CustomColor.nomadBlue
//        self.dismiss(animated: true) {
            self.present(navigationController, animated: true, completion: nil)
//        }
    }
    
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
        guard reviewHistory != nil else { return }
        ReviewListView.placeUid = selectedPlace?.placeUid
        ReviewListView.placeName.text = selectedPlace?.name
        self.present(ReviewListView, animated: true, completion: nil)
    }
}

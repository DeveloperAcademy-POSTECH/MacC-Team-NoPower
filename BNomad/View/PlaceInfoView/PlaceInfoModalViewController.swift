//
//  PlaceInfoModalViewController.swift
//  BNomad
//
//  Created by 유재훈 on 2022/10/20.
//

import UIKit
import MapKit

protocol ClearSelectedAnnotation {
    func clearAnnotation(view: MKAnnotation)
}

class PlaceInfoModalViewController: UIViewController {
    
    // MARK: - Properties
    var selectedAnnotation: MKAnnotation?
    
    let locationManager = CLLocationManager()
    lazy var currentLocation = locationManager.location
    
    var delegate: ClearSelectedAnnotation?
    
    let collectionView: UICollectionView = {
        let flowlayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        return cv
    }()
    
    var isCheckedIn: Bool = false
    
    lazy var checkInButton: UIButton = {
        var button = UIButton()
        button.setTitle("체크인 하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(checkIn), for: .touchUpInside)
        button.isHidden = self.isCheckedIn ? true : false
        return button
    }()
    
    lazy var checkOutButton: UIButton = {
        var button = UIButton()
        button.setTitle("체크아웃 하기", for: .normal)
        button.tintColor = .white
        button.backgroundColor = CustomColor.nomadGray1
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(checkOut), for: .touchUpInside)
        button.isHidden = self.isCheckedIn ? false : true
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureCheckInButton()
        setupSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let selectedAnnotation = selectedAnnotation else { return }
        delegate?.clearAnnotation(view: selectedAnnotation)
    }
    
    // MARK: - Actions
    
    @objc func checkOut() {
        print("CHECK OUT")
        let checkOutAlert = UIAlertController(title: "체크아웃 하시겠습니까?", message: "체크아웃하냐?", preferredStyle: .alert)
        checkOutAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        checkOutAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
            // TODO: Firebase에서 checkIn되어 있는 데이터 삭제하는 로직 + checkInButton 업데이트
            self.isCheckedIn = false
            self.checkInButton.isHidden = false
            self.checkOutButton.isHidden = true
        }))
        present(checkOutAlert, animated: true)
    }
    
    @objc func checkIn() {
        print("CHECK IN")
        distanceChecker()
    }
    
    // 맵의 특정 장소가 500미터 반경 이내인지 체크
    func distanceChecker() {
        let boundary = CLCircularRegion(center: currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: 500.0, identifier: "반경 500m")
        
        if boundary.contains(CLLocationCoordinate2D(latitude: selectedAnnotation?.coordinate.latitude ?? 0, longitude: selectedAnnotation?.coordinate.longitude ?? 0)) {
            let checkInAlert = UIAlertController(title: "체크인 하시겠습니까?", message: "노마드 제주에 체크인 하시겠습니까?", preferredStyle: .alert)
            checkInAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
            checkInAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { action in
                // TODO: Firebase에 올리는 작업, checkInButton 색 바로 업데이트 해야함
                // TODO: mapView 상단 체크인하고 있다는 배너 업테이트 해주어야함
                self.isCheckedIn = false
                self.checkInButton.isHidden = true
                self.checkOutButton.isHidden = false
                let controller = PlaceCheckInViewController()
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
    
    func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = CustomColor.nomadGray3
        collectionView.register(PlaceInfoCell.self, forCellWithReuseIdentifier: PlaceInfoCell.cellIdentifier)
        collectionView.register(BasicInfoCell.self, forCellWithReuseIdentifier: BasicInfoCell.cellIdentifier)
        collectionView.register(SummaryInfoCell.self, forCellWithReuseIdentifier: SummaryInfoCell.cellIdentifier)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func configureCheckInButton() {
        view.addSubview(checkInButton)
        checkInButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 17, paddingBottom: 50, paddingRight: 17, height: 50)
        
        view.addSubview(checkOutButton)
        checkOutButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 17, paddingBottom: 50, paddingRight: 17, height: 50)
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
        return 1
    }
    //enum 공부
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceInfoCell.cellIdentifier, for: indexPath) as? PlaceInfoCell else { return UICollectionViewCell() }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicInfoCell.cellIdentifier, for: indexPath) as? BasicInfoCell else { return UICollectionViewCell() }
            return cell
        }
        else if indexPath.section == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SummaryInfoCell.cellIdentifier, for: indexPath) as? SummaryInfoCell else { return UICollectionViewCell() }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
}



// MARK: - UICollectionViewDelegate

extension PlaceInfoModalViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaceInfoModalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width) / 1, height: (view.frame.width) / 1)
    }
    //셀 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
        
    }
    // 셀 크기 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 10, bottom: 8, right: 10)
    }
}

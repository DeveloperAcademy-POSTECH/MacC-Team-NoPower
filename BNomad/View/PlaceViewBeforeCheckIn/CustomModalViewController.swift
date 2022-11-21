//
//  CustomModalViewController.swift
//  BNomad
//
//  Created by 박진웅 on 2022/10/19.
//

import UIKit
import MapKit


// TODO: 화면에 보이는 map에서만 보이는 [Place] 받아와야함.
class CustomModalViewController: UIViewController {
        
    // MARK: - Properties
    
    var delegateForFloating: UpdateFloating?
    
    var position: CLLocation?
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared

    var places: [Place]? = [] {
        didSet {
            collectionView.reloadData()
            guard let places = places else { return }
            self.numberOfPlaces.text = "노마드스팟 " + String(places.count) + "개"
        }
    }
    
    lazy var numberOfPlaces: UILabel = {
        let number = UILabel()
        number.backgroundColor = .clear
        number.textColor = .black
        number.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        
        // TODO: - place.count로 변경 필요.
        number.text = ""
        number.textAlignment = .center
        number.translatesAutoresizingMaskIntoConstraints = false
        return number
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let guideline = UICollectionViewFlowLayout()
        guideline.scrollDirection = .vertical
        guideline.minimumLineSpacing = 12
        guideline.minimumInteritemSpacing = 0
        return guideline
    }()

    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = true
        view.scrollIndicatorInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 4)
        view.contentInset = .zero
        view.layer.backgroundColor = CustomColor.nomad2White?.cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationmanager = CLLocationManager()
        locationmanager.delegate = self
        
        
        self.view.layer.backgroundColor = CustomColor.nomad2White?.cgColor
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = .init(width: 0, height: -2)
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.5
        self.view.addSubview(numberOfPlaces)
        self.view.addSubview(collectionView)

        numberOfPlaces.anchor(top: view.topAnchor, paddingTop: 22)
        numberOfPlaces.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionView.anchor(top: numberOfPlaces.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingRight: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
    }
    
    func locationCheck(){
            let status = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted {
                let alter = UIAlertController(title: "위치 접근 허용 설정이 제한되어 있습니다.", message: "해당 장소의 장소보기 및 체크인 기능을 사용하려면, 위치 접근을 허용해주셔야 합니다. 앱 설정으로 이동하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                let logOkAction = UIAlertAction(title: "설정", style: UIAlertAction.Style.default){
                    (action: UIAlertAction) in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(NSURL(string:UIApplication.openSettingsURLString)! as URL)
                    } else {
                        UIApplication.shared.openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
                    }
                }
                let logNoAction = UIAlertAction(title: "취소", style: UIAlertAction.Style.destructive)
                alter.addAction(logNoAction)
                alter.addAction(logOkAction)
                self.present(alter, animated: true, completion: nil)
            }
        }
}

// MARK: - UICollectionViewDataSource

extension CustomModalViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let places = places else {return 9}
        return places.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as? CustomCollectionViewCell else  { return UICollectionViewCell() }
        guard var places = places else { return UICollectionViewCell() }
        guard let position = self.position else { return UICollectionViewCell() }
        let latitude: Double = position.coordinate.latitude
        let longitude: Double = position.coordinate.longitude
        places.sort(by: { CustomCollectionViewCell.calculateDistance(latitude1: latitude, latitude2: $0.latitude, longitude1: longitude, longitude2: $0.longitude) < CustomCollectionViewCell.calculateDistance(latitude1: latitude, latitude2: $1.latitude, longitude1: longitude, longitude2: $1.longitude)})
        cell.place = places[indexPath.item]
        cell.position = position
        if places[indexPath.item].placeUid == viewModel.user?.currentPlaceUid {
            cell.cell.layer.borderColor = CustomColor.nomadBlue?.cgColor
            cell.cell.layer.borderWidth = 1
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

// MARK: - UICollectionViewDelegate

extension CustomModalViewController: UICollectionViewDelegate, CLLocationManagerDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PlaceInfoModalViewController()
        locationCheck()
        guard var places = places else { return }
        guard let position = self.position else { return }
        let latitude: Double = position.coordinate.latitude
        let longitude: Double = position.coordinate.longitude
        places.sort(by: { CustomCollectionViewCell.calculateDistance(latitude1: latitude, latitude2: $0.latitude, longitude1: longitude, longitude2: $0.longitude) < CustomCollectionViewCell.calculateDistance(latitude1: latitude, latitude2: $1.latitude, longitude1: longitude, longitude2: $1.longitude)})
        controller.selectedPlace = places[indexPath.item]
        controller.delegateForFloating = self
        present(controller, animated: true)
        // TODO: map의 해당 선택된 region으로 움직여줘야 한다.
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CustomModalViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellHeight = screenWidth * 80/390
        
        return CGSize(width: view.bounds.width, height: cellHeight)
    }
    
}

// MARK: - UpdateFloating

extension CustomModalViewController: UpdateFloating {
    func checkInFloating() {
        self.delegateForFloating?.checkInFloating()
    }
}

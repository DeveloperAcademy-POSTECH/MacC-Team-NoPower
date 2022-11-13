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
            guard var places = places else { return }
            self.numberOfPlaces.text = "업무 공간 " + String(places.count) + "개"
        }
    }
    
    var rectangle: UIView = {
        let rectangle = UIView()
        rectangle.frame = CGRect(x: 0, y: 0, width: 80, height: 5)
        rectangle.layer.cornerRadius = 3
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        rectangle.backgroundColor = .systemGray2
        return rectangle
    }()
    
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
        guideline.minimumLineSpacing = 9
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
        view.layer.backgroundColor = UIColor(red: 0.967, green: 0.967, blue: 0.967, alpha: 1).cgColor
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//    places: [Place] = {
//        let placesOnMap = viewModel.places.filter(map)
//    }
//        viewModel.places
        
//        self.view.layer.backgroundColor = UIColor(red: 0.967, green: 0.967, blue: 0.967, alpha: 1).cgColor
        self.view.layer.backgroundColor = CustomColor.nomadGray3?.cgColor
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.view.layer.shadowColor = UIColor.black.cgColor
        self.view.layer.shadowOffset = .init(width: 0, height: -2)
        self.view.layer.shadowRadius = 20
        self.view.layer.shadowOpacity = 0.5
        
        self.view.addSubview(rectangle)
        self.view.addSubview(numberOfPlaces)
        self.view.addSubview(collectionView)
        
    
        rectangle.anchor(top: view.topAnchor, paddingTop: 15, width: 80, height: 5)
        rectangle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        numberOfPlaces.anchor(top: rectangle.topAnchor, paddingTop: 18)
        numberOfPlaces.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionView.anchor(top: numberOfPlaces.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 33, paddingLeft: 0, paddingRight: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        
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
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

// MARK: - UICollectionViewDelegate

extension CustomModalViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PlaceInfoModalViewController()
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
        return CGSize(width: view.bounds.width, height: 86)
    }
    
}


extension CustomModalViewController: UpdateFloating {
    func checkInFloating() {
        self.delegateForFloating?.checkInFloating()
    }
}

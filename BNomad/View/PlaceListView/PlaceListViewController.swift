//
//  CustomModalViewController.swift
//  BNomad
//
//  Created by 박진웅 on 2022/10/19.
//

import UIKit
import MapKit

class PlaceListViewController: UIViewController {
        
    // MARK: - Properties
    
    var delegateForFloating: UpdateFloating?
    var regionChangeDelegate: setMap?

    var position: CLLocation?
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared

    var places: [Place]? = [] {
        didSet {
            guard let places = places else { return }
            self.numberOfPlaces.text = "노마드스팟 " + String(places.count) + "개"
        }
    }
    
    lazy var numberOfPlaces: UILabel = {
        let number = UILabel()
        number.backgroundColor = .clear
        number.textColor = .black
        number.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
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
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.scrollIndicatorInsets = UIEdgeInsets(top: 2, left: 0, bottom: 0, right: 4)
        view.layer.backgroundColor = CustomColor.nomad2White?.cgColor
        return view
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layer.backgroundColor = CustomColor.nomad2White?.cgColor
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .init(width: 0, height: -2)
        view.layer.shadowRadius = 20
        view.layer.shadowOpacity = 0.5
        view.addSubview(numberOfPlaces)
        view.addSubview(collectionView)

        numberOfPlaces.anchor(top: view.topAnchor, paddingTop: 22)
        numberOfPlaces.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        collectionView.anchor(top: numberOfPlaces.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 0, paddingRight: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PlaceListCollectionViewCell.self, forCellWithReuseIdentifier: PlaceListCollectionViewCell.identifier)
    }
    
}

// MARK: - UICollectionViewDataSource

extension PlaceListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let places = places else {return 9}
        return places.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceListCollectionViewCell.identifier, for: indexPath) as? PlaceListCollectionViewCell else  { return UICollectionViewCell() }
        guard let places = places else { return UICollectionViewCell() }
        cell.place = places[indexPath.item]
        cell.position = position
        if places[indexPath.item].placeUid == viewModel.user?.currentPlaceUid {
            cell.layer.borderColor = CustomColor.nomadBlue?.cgColor
            cell.layer.borderWidth = 1
            cell.layer.backgroundColor = CustomColor.nomadBlue?.withAlphaComponent(0.15).cgColor
            cell.workingLabel.isHidden = false
        } else {
            cell.layer.borderWidth = 0
            cell.layer.backgroundColor = UIColor.white.cgColor
            cell.workingLabel.isHidden = true
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

// MARK: - UICollectionViewDelegate

extension PlaceListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PlaceInfoModalViewController()
        guard let places = places else { return }
        controller.selectedPlace = places[indexPath.item]
        controller.delegateForFloating = self
        present(UINavigationController(rootViewController: controller), animated: true)
        regionChangeDelegate?.setMapRegion(controller.selectedPlace!.latitude - 0.002, controller.selectedPlace!.longitude, spanDelta: 0.005)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlaceListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let cellHeight = screenWidth * 80/390
        return CGSize(width: screenWidth - 40, height: cellHeight)
    }
    
}

// MARK: - UpdateFloating

extension PlaceListViewController: UpdateFloating {
    func checkInFloating() {
        self.delegateForFloating?.checkInFloating()
    }
}

//
//  ProfileListViewController.swift
//  BNomad
//
//  Created by 김예은 on 2022/10/18.
//

import UIKit

class PlaceCheckInViewController: UIViewController {
    
    // MARK: - Properties
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeCheckInView()
        collectionView.backgroundColor = .white
    }

    // MARK: - Helps
    
    func placeCheckInView() {

        view.addSubview(collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CheckedProfileListViewCell.self, forCellWithReuseIdentifier: CheckedProfileListViewCell.identifier)
        self.collectionView.register(ColorViewCell.self, forCellWithReuseIdentifier: ColorViewCell.identifier)
        self.collectionView.register(UserProfileViewCell.self, forCellWithReuseIdentifier: UserProfileViewCell.identifier)
        self.collectionView.register(PlaceInforViewCell.self, forCellWithReuseIdentifier: PlaceInforViewCell.identifier)
        self.collectionView.register(CheckedProfileListHeader.self, forCellWithReuseIdentifier: CheckedProfileListHeader.identifier)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
}

// MARK: - Extentions

extension PlaceCheckInViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 4 {
            return 10
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let placeInforViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceInforViewCell.identifier, for: indexPath) as? PlaceInforViewCell else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            guard let userProfileViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileViewCell.identifier, for: indexPath) as? UserProfileViewCell else { return UICollectionViewCell() }
            return userProfileViewCell
        }
        else if indexPath.section == 1 {
            guard let colorViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorViewCell.identifier, for: indexPath) as? ColorViewCell else { return UICollectionViewCell() }
            return colorViewCell
        }
        else if indexPath.section == 3 {
            guard let CheckedProfileListHeader = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListHeader.identifier, for: indexPath) as? CheckedProfileListHeader else { return UICollectionViewCell() }
            return CheckedProfileListHeader
        }
        else if indexPath.section == 4 {
            guard let checkedProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListViewCell.identifier, for: indexPath) as? CheckedProfileListViewCell else { return UICollectionViewCell() }
            
            checkedProfileCell.backgroundColor = .white
            checkedProfileCell.layer.borderWidth = 1
            checkedProfileCell.layer.borderColor = CustomColor.nomadGray2?.cgColor
            checkedProfileCell.layer.cornerRadius = 12
            return checkedProfileCell
        }
        return placeInforViewCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
}

extension PlaceCheckInViewController: UICollectionViewDelegateFlowLayout {
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: 390, height: 160)
        } else if indexPath.section == 1 {
            return CGSize(width: 390, height: 10)
        } else if indexPath.section == 2 {
            return CGSize(width: 390, height: 220)
        } else if indexPath.section == 3 {
            return CGSize(width: 390, height: 40)
        } else if indexPath.section == 4 {
            return CGSize(width: 356, height: 85)
        }
        return CGSize(width: 390, height: 0)
    }
}





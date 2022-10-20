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
        collectionView.backgroundColor = CustomColor.nomadGray2
    }


    // MARK: - Helps
    
    func placeCheckInView() {

        view.addSubview(collectionView)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CheckedProfileListViewCell.self, forCellWithReuseIdentifier: CheckedProfileListViewCell.identifier)
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
        if section == 3 {
            return 10
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let checkedProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListViewCell.identifier, for: indexPath) as? CheckedProfileListViewCell else {
            return UICollectionViewCell()
        }
        
        guard let userProfileViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UserProfileViewCell.identifier, for: indexPath) as? UserProfileViewCell else {
            return UICollectionViewCell()
        }
        
        guard let CheckedProfileListHeader = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListHeader.identifier, for: indexPath) as? CheckedProfileListHeader else {
            return UICollectionViewCell()
        }
        
        guard let placeInforViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceInforViewCell.identifier, for: indexPath) as? PlaceInforViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            userProfileViewCell.backgroundColor = .white
            return userProfileViewCell
        }
        else if indexPath.section == 3 {
            
            checkedProfileCell.backgroundColor = .white
            checkedProfileCell.layer.borderWidth = 1
            checkedProfileCell.layer.borderColor = CustomColor.nomadGray2?.cgColor
            checkedProfileCell.layer.cornerRadius = 12
            return checkedProfileCell
        } else if indexPath.section == 2 {
            CheckedProfileListHeader.backgroundColor = .white
            return CheckedProfileListHeader
        }
//        checkedProfileCell.backgroundColor = .white
        return placeInforViewCell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        // 섹션의 헤더 너비와 높이 설정
//            let width = collectionView.frame.width
//            let height: CGFloat = 80
//            return CGSize(width: width, height: height)
//    }
}


extension PlaceCheckInViewController: UICollectionViewDelegateFlowLayout {
    
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 3 {
            return CGSize(width: 356, height: 85)
        } else if indexPath.section == 0 {
            return CGSize(width: 390, height: 160)
        } else if indexPath.section == 2 {
            return CGSize(width: 390, height: 40)
        }
        return CGSize(width: 390, height: 220)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
    
    // 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}





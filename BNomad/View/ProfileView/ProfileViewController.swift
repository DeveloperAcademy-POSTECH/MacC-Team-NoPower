//
//  ProfileViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: -Properties
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = resizeImage(image: UIImage(named: "ProfileDefault")!, targetSize: CGSize(width: 78.0, height: 78.0))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let profileCollectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(hex: "F5F5F5")
        collectionView.register(SelfUserInfoCell.self, forCellWithReuseIdentifier: SelfUserInfoCell.identifier)
        collectionView.register(VisitingInfoCell.self, forCellWithReuseIdentifier: VisitingInfoCell.identifier)
        collectionView.register(ProfileGraphCell.self, forCellWithReuseIdentifier: ProfileGraphCell.identifier)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: -Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "F5F5F5")
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        configureUI()
        render()
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Actions

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    //MARK: -Helpers
    
    func configureUI() {
        
    }
    
    func render() {
        
        view.addSubview(profileImageView)
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 136).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 29).isActive = true


        
        view.addSubview(profileCollectionView)
        profileCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 234).isActive = true
        profileCollectionView.heightAnchor.constraint(equalToConstant: 570).isActive = true
        profileCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        profileCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
    }
    
}

//MARK: -Extentions

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelfUserInfoCell.identifier , for: indexPath) as? SelfUserInfoCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 20
        return cell
        }else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitingInfoCell.identifier , for: indexPath) as? VisitingInfoCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            return cell
        }else {
            print(indexPath)
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileGraphCell.identifier , for: indexPath) as? ProfileGraphCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            return cell
        }
        
    }

}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if indexPath.section == 0 {
            return CGSize(width: 358, height: 166)
        } else if indexPath.section == 1 {
            return CGSize(width: 358, height: 119)
        } else {
            return CGSize(width: 358, height: 190)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        }
    
}

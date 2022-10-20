//
//  ProfileViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: -Properties
    
    static var weekAddedMemory: Int = 0
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = resizeImage(image: UIImage(named: "ProfileDefault")!, targetSize: CGSize(width: 78.0, height: 78.0))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let plusWeek: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let minusWeek: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        button.setTitleColor(CustomColor.nomadSkyblue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let profileGraphCellHeaderLabel: UILabel = {
        let label = UILabel()
        
        profileGraphCellHeaderMaker(label: label, weekAdded: 0)
        label.font = .preferredFont(forTextStyle: .title3, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileCollectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
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
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        plusWeek.addTarget(self, action: #selector(plusWeekTapButton), for: .touchUpInside)
        minusWeek.addTarget(self, action: #selector(minusWeekTapButton), for: .touchUpInside)
        
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
    
    static func profileGraphCellHeaderMaker(label: UILabel, weekAdded: Int) {
        
        
        weekAddedMemory += weekAdded
        let weekCalculator = weekAddedMemory * 7
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        
        let sundayCalculator = (86400 * (1-Contents.todayOfTheWeek+1 + weekCalculator))
        let saturdayCalculator = (86400 * (1-Contents.todayOfTheWeek+7 + weekCalculator))
        
        let sundayDate = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(sundayCalculator)))
        let saturdayDate = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(saturdayCalculator)))
        
        label.text = sundayDate+" ~ "+saturdayDate
    }
        
        
    @objc func plusWeekTapButton() {
        ProfileGraphCell.editWeek(edit: 1)
        profileCollectionView.reloadData()
        
        ProfileViewController.profileGraphCellHeaderMaker(label: profileGraphCellHeaderLabel, weekAdded: 1)
    }
    
    @objc func minusWeekTapButton() {
        ProfileGraphCell.editWeek(edit: -1)
        profileCollectionView.reloadData()
        
        ProfileViewController.profileGraphCellHeaderMaker(label: profileGraphCellHeaderLabel, weekAdded: -1)
    }
    
    //MARK: -Helpers
    
    func configureUI() {
        view.backgroundColor = UIColor(hex: "F5F5F5")
    }
    
    func render() {
        
        view.addSubview(profileImageView)
        profileImageView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 120, paddingLeft: 29)
        
        
        
        view.addSubview(profileCollectionView)
        profileCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                     paddingTop: 220, paddingLeft: 16, paddingRight: 16,
                                     height: 600)
        
        
        view.addSubview(profileGraphCellHeaderLabel)
        profileGraphCellHeaderLabel.anchor(top: view.topAnchor, paddingTop: 570)
        profileGraphCellHeaderLabel.centerX(inView: view)
        
        view.addSubview(minusWeek)
        minusWeek.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 570, paddingLeft: 45)
        
        view.addSubview(plusWeek)
        plusWeek.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: 570, paddingRight: 45)
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

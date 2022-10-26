//
//  ProfileViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Properties
//    let userUid = "04d3acd1-a6ec-465e-845e-a319e42180e6"
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    
//    var user: User? {
//        didSet {
//            profileCollectionView.reloadData()
//        }
//    }
//    var checkInHistory: [CheckIn]? {
//        didSet {
//            profileCollectionView.reloadData()
//            ProfileGraphCollectionView.reloadData()
//        }
//    }
    
    static var weekAddedMemory: Int = 0
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = Contents.resizeImage(image: UIImage(named: "ProfileDefault") ?? UIImage(), targetSize: CGSize(width: 78.0, height: 78.0)) 
        return iv
    }()
    
    private lazy var DummyGraphImage: UIImageView = { //FIXME: 더미 그래프 이미지임 로직 생성 필요
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = UIImage(named: "graph")
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
    
    private let ProfileGraphCollectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .white
        collectionView.register(ProfileGraphCollectionCell.self, forCellWithReuseIdentifier: ProfileGraphCollectionCell.identifier)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ProfileViewController.profileGraphCellHeaderMaker(label: profileGraphCellHeaderLabel, weekAdded: -ProfileViewController.weekAddedMemory)
        ProfileGraphCell.addedWeek = 0
        ProfileGraphCell.editWeek(edit: 0)
        
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        ProfileGraphCollectionView.dataSource = self
        ProfileGraphCollectionView.delegate = self
        
        plusWeek.addTarget(self, action: #selector(plusWeekTapButton), for: .touchUpInside)
        minusWeek.addTarget(self, action: #selector(minusWeekTapButton), for: .touchUpInside)
        
        configureUI()
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(moveToCalendar))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Actions
    
    @objc func moveToCalendar() {
        CalendarViewController.checkInHistory = viewModel.user?.checkInHistory
        navigationController?.pushViewController(CalendarViewController(), animated: true)
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if (widthRatio > heightRatio) {
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
        
        let sundayCalculator = (86400 * (1-Contents.todayOfTheWeek + weekCalculator))
        let saturdayCalculator = (86400 * (1-Contents.todayOfTheWeek+6 + weekCalculator))
        
        let sundayDate = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(sundayCalculator)))
        let saturdayDate = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(saturdayCalculator)))
        
        label.text = sundayDate+" ~ "+saturdayDate
    }
        
        
    @objc func plusWeekTapButton() {
        ProfileGraphCell.editWeek(edit: 1)
        profileCollectionView.reloadData()
        ProfileGraphCollectionView.reloadData()
        
        ProfileViewController.profileGraphCellHeaderMaker(label: profileGraphCellHeaderLabel, weekAdded: 1)
    }
    
    @objc func minusWeekTapButton() {
        ProfileGraphCell.editWeek(edit: -1)
        profileCollectionView.reloadData()
        ProfileGraphCollectionView.reloadData()
        
        ProfileViewController.profileGraphCellHeaderMaker(label: profileGraphCellHeaderLabel, weekAdded: -1)
    }
    
    // MARK: - Helpers
    
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
        
        view.addSubview(ProfileGraphCollectionView)
        ProfileGraphCollectionView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 615, paddingLeft: 58, width: 286, height: 154)
    }
    
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == profileCollectionView {
            return 3
        }else {
            return 1
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == profileCollectionView {
            return 1
        }else {
            return 7
        }
    }
    
}

// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == profileCollectionView {
            
            if indexPath.section == 0 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelfUserInfoCell.identifier , for: indexPath) as? SelfUserInfoCell else {
                return UICollectionViewCell()
            }
                cell.user = viewModel.user
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 20
                cell.delegate = self
                return cell
            } else if indexPath.section == 1 {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitingInfoCell.identifier , for: indexPath) as? VisitingInfoCell else {
                    return UICollectionViewCell()
                }
                
                cell.checkInHistoryForProfile = viewModel.user?.checkInHistory
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 20
                return cell
            } else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileGraphCell.identifier , for: indexPath) as? ProfileGraphCell else {
                    return UICollectionViewCell()
                }
                
                let year = "2022"
                let month = String(format: "%02d", (Contents.todayDate()["month"] ?? 0))
                let day = String(format: "%02d", (Contents.todayDate()["day"] ?? 0) + ProfileViewController.weekAddedMemory*7)
                let dateString = year+"-"+month+"-"+day
                
                cell.thisCellsDate = dateString
                cell.checkInHistory = viewModel.user?.checkInHistory
                
                cell.backgroundColor = .white
                cell.layer.cornerRadius = 20
                return cell
            }
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileGraphCollectionCell.identifier , for: indexPath) as? ProfileGraphCollectionCell else {
                return UICollectionViewCell()
            }
            
            let weekCalculator = ProfileViewController.weekAddedMemory * 7
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let dayCalculator = (86400 * (1-Contents.todayOfTheWeek + weekCalculator + indexPath.item))
            let cellDate = formatter.string(from: Date(timeIntervalSinceNow: TimeInterval(dayCalculator)))
            
            cell.cellDate = cellDate
            cell.checkInHistory = viewModel.user?.checkInHistory
            cell.backgroundColor = .white
            return cell
        }
    }
  
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == profileCollectionView {
            if indexPath.section == 0 {
                return CGSize(width: 358, height: 166)
            } else if indexPath.section == 1 {
                return CGSize(width: 358, height: 119)
            } else {
                return CGSize(width: 358, height: 190)
            }
        }else {
            return CGSize(width: 27, height: 154)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            if collectionView == profileCollectionView {
               return UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
            }else {
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == profileCollectionView {
            return CGFloat(0)
        }else {
            return CGFloat(15)
        }
    }
}

// MARK: - MovePage

extension ProfileViewController: MovePage {
    func moveToEditingPage() {
        ProfileEditViewController.user = viewModel.user
        navigationController?.pushViewController(ProfileEditViewController(), animated: true)
    }
}


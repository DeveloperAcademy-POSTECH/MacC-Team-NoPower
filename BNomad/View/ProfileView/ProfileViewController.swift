//
//  ProfileViewController.swift
//  BNomad
//
//  Created by 박성수 on 2022/10/17.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    lazy var viewModel: CombineViewModel = CombineViewModel.shared
    
    static var weekAddedMemory: Int = 0
    
    var isMyProfile: Bool?
    
    var nomad: User? {
        didSet {
            guard let profileImageUrl = nomad?.profileImageUrl else { return }
            profileImageView.kf.setImage(with: URL(string: profileImageUrl))
            self.profileCollectionView.reloadData()
            
        }
    }
    
    lazy var editingButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("프로필 수정", for: .normal)
        button.tintColor = CustomColor.nomadGray1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(moveToEditingPage), for: .touchUpInside)
        return button
    }()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = CustomColor.nomad2White
        
        return scroll
    }()
    
    let contentView: UIView = {
        let ui = UIView()
        ui.backgroundColor = CustomColor.nomad2White
        return ui
    }()
    
    private lazy var profileImageView = ProfileUIImageView(widthRatio: 120)
    
    private let profileCollectionView:  UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = CustomColor.nomad2White
        collectionView.register(SelfUserInfoCell.self, forCellWithReuseIdentifier: SelfUserInfoCell.identifier)
        collectionView.register(VisitCardCell.self, forCellWithReuseIdentifier: VisitCardCell.identifier)
        collectionView.register(ProfileGraphCell.self, forCellWithReuseIdentifier: ProfileGraphCell.identifier)
        
        collectionView.register(ProfileHeaderCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderCollectionView.identifier)
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonTitle = ""
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "calendar"), style: .plain, target: self, action: #selector(moveToCalendar))
        
        ProfileGraphCell.addedWeek = 0
        ProfileGraphCell.editWeek(edit: 0)
        
        
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        
        profileImageView.image = nomad?.profileImage ?? UIImage(named: "othersProfile")
        
        configureUI()
        render()
        
        if !(isMyProfile ?? true) {
            editingButton.removeFromSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = CustomColor.nomadBlue
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = false

        profileImageView.image = nomad?.profileImage ?? UIImage(named: "othersProfile")
    }
    
    
    // MARK: - Actions
    
    @objc func moveToCalendar() {
        //        if userFromListUid == viewModel.user?.userUid || FirebaseAuth와 지금 viewModel.user가 같은 uid인지 체크 {
        CalendarViewController.checkInHistory = nomad?.checkInHistory
        navigationController?.pushViewController(CalendarViewController(), animated: true)
        //        } else {
        //            print("다른 사람의 캘린더뷰는 보지 못합니다")
        //        }
    }
    
    @objc func moveToVisitCollection() {
        VisitCardCollectionViewController.checkInHistory = nomad?.checkInHistory
        navigationController?.pushViewController(VisitCardCollectionViewController(), animated: true)
    }
    
    @objc func moveToEditingPage() {
        let vc = ProfileEditViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = CustomColor.nomad2White
    }
    
    func render() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        contentView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor)

        let contentViewHeight = contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        contentViewHeight.priority = .defaultLow
        contentViewHeight.isActive = true
        
        scrollView.addSubview(profileCollectionView)
        scrollView.addSubview(profileImageView)
        scrollView.addSubview(editingButton)
        
        profileImageView.anchor(top: scrollView.topAnchor, paddingTop: 20, width: 120, height: 120)
        profileImageView.centerX(inView: view)
        
        profileCollectionView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: view.rightAnchor,
                                             paddingTop: 100, paddingLeft: 16, paddingRight: 16,
                                             height: 700)
        
        editingButton.anchor(top: profileCollectionView.topAnchor, right: profileCollectionView.rightAnchor, paddingTop: 12, paddingRight: 12, width: 55, height: 13)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
}

// MARK: - UICollectionViewDelegate

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelfUserInfoCell.identifier , for: indexPath) as? SelfUserInfoCell else {
                return UICollectionViewCell()
            }
            cell.user = nomad
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitCardCell.identifier , for: indexPath) as? VisitCardCell else {
                return UICollectionViewCell()
            }
            cell.layer.borderWidth = 2
            cell.layer.borderColor = CustomColor.nomadBlue?.cgColor
            cell.checkInHistoryForProfile = nomad?.checkInHistory
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileGraphCell.identifier , for: indexPath) as? ProfileGraphCell else {
                return UICollectionViewCell()
            }
            
            cell.checkInHistory = nomad?.checkInHistory
            
            cell.backgroundColor = .white
            cell.layer.cornerRadius = 20
            return cell
            
        default:
            return UICollectionViewCell()
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            moveToCalendar() //TODO: 왜 리스트부터 띄우질 못할까요
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionView.identifier, for: indexPath) as? ProfileHeaderCollectionView else {
            return UICollectionViewCell()
        }
        
        header.delegate = self

        switch indexPath.section {
        case 1:
            header.setVisitCardHeader()
        case 2:
            header.setGraphHeader()
        default: break
        }
        
        return header
        
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        switch indexPath.section {
        case 0:
            return CGSize(width: profileCollectionView.frame.width, height: 182)
        case 1:
            return CGSize(width: profileCollectionView.frame.width, height: 119)
        case 2:
            return CGSize(width: profileCollectionView.frame.width, height: 220)
        default:
            return CGSize(width: profileCollectionView.frame.width, height: 190)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return .zero
        case 1:
            return CGSize(width: view.frame.size.width, height: 62)
        case 2:
            return CGSize(width: view.frame.size.width, height: 62)
        default:
            return .zero
        }
    }
    
}

//MARK: - PlusMinus

extension ProfileViewController: PlusMinusProtocol {
    func plusTap() {
        ProfileGraphCell.editWeek(edit: 1)
    }
    
    func minusTap() {
        ProfileGraphCell.editWeek(edit: -1)
    }
    
    func viewAllTap() {
        self.moveToCalendar()
    }
}

// MARK: - EditNow
extension ProfileViewController: EditNow {
    func editNow() {
        profileCollectionView.reloadData()
    }
    
}

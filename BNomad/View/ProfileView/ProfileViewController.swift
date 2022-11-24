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
    
    var userFromListUid: String?
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = CustomColor.nomad2White
        scroll.canCancelContentTouches = true
        
        return scroll
    }()
    
    class myCollectionView: UIScrollView {
        override func touchesShouldCancel(in view: UIView) -> Bool {
            if view is UICollectionView {
                return false
            }
            return super.touchesShouldCancel(in: view)
        }
    }
    
    let contentView: UIView = {
        let ui = UIView()
        ui.backgroundColor = CustomColor.nomad2White
        return ui
    }()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        if viewModel.user?.profileImage == nil {
            if let profileImageUrl = viewModel.user?.profileImageUrl {
                iv.kf.setImage(with: URL(string: profileImageUrl))
            }
        }
        iv.frame = CGRect(origin: .zero, size: CGSize(width: 120,height: 120))
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = iv.frame.width / 2
        return iv
    }()
    
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
        
        configureUI()
        render()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = CustomColor.nomadBlue
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.isHidden = false

        profileImageView.image = viewModel.user?.profileImage ?? UIImage(named: "othersProfile")
    }
    
    
    // MARK: - Actions
    
    @objc func moveToCalendar() {
        //        if userFromListUid == viewModel.user?.userUid || FirebaseAuth와 지금 viewModel.user가 같은 uid인지 체크 {
        CalendarViewController.checkInHistory = viewModel.user?.checkInHistory
        navigationController?.pushViewController(CalendarViewController(), animated: true)
        //        } else {
        //            print("다른 사람의 캘린더뷰는 보지 못합니다")
        //        }
    }
    
    @objc func moveToVisitCollection() {
        VisitCardCollectionViewController.checkInHistory = viewModel.user?.checkInHistory
        navigationController?.pushViewController(VisitCardCollectionViewController(), animated: true)
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
        
        profileImageView.anchor(top: scrollView.topAnchor, paddingTop: 20, width: profileImageView.frame.width, height: profileImageView.frame.height)
        profileImageView.centerX(inView: view)
        
        profileCollectionView.anchor(top: scrollView.topAnchor, left: scrollView.leftAnchor, right: view.rightAnchor,
                                             paddingTop: 100, paddingLeft: 16, paddingRight: 16,
                                             height: 700)
        
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
            cell.user = viewModel.user
            cell.backgroundColor = .systemBackground
            cell.layer.cornerRadius = 20
            cell.delegate = self
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VisitCardCell.identifier , for: indexPath) as? VisitCardCell else {
                return UICollectionViewCell()
            }
            cell.layer.borderWidth = 2
            cell.layer.borderColor = CustomColor.nomadBlue?.cgColor
            cell.checkInHistoryForProfile = viewModel.user?.checkInHistory
            cell.backgroundColor = .systemBackground
            cell.layer.cornerRadius = 20
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileGraphCell.identifier , for: indexPath) as? ProfileGraphCell else {
                return UICollectionViewCell()
            }
            
            cell.checkInHistory = viewModel.user?.checkInHistory
            
            cell.backgroundColor = .systemBackground
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
        
        header.delegate = self //FIXME: 매 로드때마다 딜리게이트 설정해주는게 맞는지?

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
        if indexPath.section == 0 {
            return CGSize(width: profileCollectionView.frame.width, height: 182)
        } else if indexPath.section == 1 {
            return CGSize(width: profileCollectionView.frame.width, height: 119)
        } else {
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
            return CGSize(width: view.frame.size.width, height: 96)
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

// MARK: - MovePage

extension ProfileViewController: MovePage {
    func moveToEditingPage() {
        let vc = ProfileEditViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

// MARK: - EditNow
extension ProfileViewController: EditNow {
    func editNow() {
        profileCollectionView.reloadData()
    }
    
}

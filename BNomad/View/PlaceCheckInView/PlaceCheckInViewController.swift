//
//  ProfileListViewController.swift
//  BNomad
//
//  Created by 김예은 on 2022/10/18.
//

import UIKit

class PlaceCheckInViewController: UIViewController {
    
    // MARK: - Properties
    
    // 유저 정보 -> 헤더로 변경 예정
    let userProfileImg: UIImageView = {
        let userProfileImg = UIImageView()
        userProfileImg.image = UIImage(named: "profileDefault")
        userProfileImg.translatesAutoresizingMaskIntoConstraints = false
        return userProfileImg
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "김노마 (나)"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
        label.textColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "커피챗 환영합니다:P"
        label.font = .preferredFont(forTextStyle: .body, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let placeCheckInViewProfileLine: UIImageView = {
        let divider = UIImageView()
        divider.image = UIImage(named: "placeCheckInViewProfileLine")
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    let rectangleDivider: UIImageView = {
        let divider = UIImageView()
        divider.image = UIImage(named: "rectangleDivider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    
    // 아래로 공간정보
    let placeNameLable: UILabel = {
        let label = UILabel()
        label.text = "노마딕 제주"
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        label.textColor = CustomColor.nomadBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "제주시"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "locationIcon")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()
    
    let placeNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "인포데스크는 오전 10시 - 오후 4시 사이에만 운영됩니다. (점심시간포함)"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // 해당 공간에 체크인한 사람
//    private let checkedProfileListView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        // 기본 보기형식 : 리스트로 보기
//        layout.scrollDirection = .vertical
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//
//
//
//        return collectionView
//    }()
    private let checkedProfileListView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileInfoView()
        view.addSubview(rectangleDivider)
        rectangleDivider.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 211, paddingLeft: 0)
        placeInfoView()
        
        // checkedProfileListView
        self.checkedProfileListView.dataSource = self
        self.checkedProfileListView.delegate = self
        self.checkedProfileListView.register(CheckedProfileListViewCell.self, forCellWithReuseIdentifier: CheckedProfileListViewCell.identifier)
        view.addSubview(checkedProfileListView)
        checkedProfileListView.translatesAutoresizingMaskIntoConstraints = false
        checkedProfileListView.topAnchor.constraint(equalTo: view.topAnchor, constant: 468).isActive = true
        checkedProfileListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17).isActive = true
        checkedProfileListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        checkedProfileListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17).isActive = true
        
        view.backgroundColor = .systemBackground
    }
    
    
    // MARK: - Helps
    func profileInfoView() {
        // 프로필 이미지
        view.addSubview(userProfileImg)
        userProfileImg.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 113, paddingLeft: 26)
        // 사용자 이름
        view.addSubview(usernameLabel)
        usernameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 121, paddingLeft: 125)
        // 직업
        view.addSubview(occupationLabel)
        occupationLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 130, paddingLeft: 260)
        
        // 구분선
        view.addSubview(placeCheckInViewProfileLine)
        placeCheckInViewProfileLine.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 152, paddingLeft: 125)
        
        // 상태 메세지
        view.addSubview(noteLabel)
        noteLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 158, paddingLeft: 125)
    }
    
    func placeInfoView() {
        // 공간 이름
        view.addSubview(placeNameLable)
        placeNameLable.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 235, paddingLeft: 17)
        // 픽토그램
        view.addSubview(locationIcon)
        locationIcon.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 262, paddingLeft: 18)
        // 소재지
        view.addSubview(locationLabel)
        locationLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 261, paddingLeft: 28)
        // 공지사항
        view.addSubview(placeNoteLabel)
        placeNoteLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 285, paddingLeft: 18)
    }
}


// MARK: - Extentions

extension PlaceCheckInViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // check
        print(indexPath)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListViewCell.identifier, for: indexPath) as? CheckedProfileListViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .white
        cell.layer.borderWidth = 1
        cell.layer.borderColor = CustomColor.nomadGray2?.cgColor
        cell.layer.cornerRadius = 12
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}


extension PlaceCheckInViewController: UICollectionViewDelegateFlowLayout {
    // cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 356, height: 85)
    }
}

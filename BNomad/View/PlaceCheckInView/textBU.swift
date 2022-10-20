////
////  ProfileListViewController.swift
////  BNomad
////
////  Created by 김예은 on 2022/10/18.
////
//
//import UIKit
//
//class PlaceCheckInViewController: UIViewController {
//
//    // MARK: - Properties
//
////    // 유저 정보 -> 헤더로 변경 예정
////    let userProfileImg: UIImageView = {
////        let userProfileImg = UIImageView()
////        userProfileImg.image = UIImage(named: "profileDefault")
////        userProfileImg.translatesAutoresizingMaskIntoConstraints = false
////        return userProfileImg
////    }()
////
////    let usernameLabel: UILabel = {
////        let label = UILabel()
////        label.text = "김노마 (나)"
////        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
////
////    let occupationLabel: UILabel = {
////        let label = UILabel()
////        label.text = "iOS Developer"
////        label.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
////        label.textColor = CustomColor.nomadGray1
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
////
////    let noteLabel: UILabel = {
////        let label = UILabel()
////        label.text = "커피챗 환영합니다:P"
////        label.font = .preferredFont(forTextStyle: .body, weight: .regular)
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
////
////    let placeCheckInViewProfileLine: UIImageView = {
////        let divider = UIImageView()
////        divider.image = UIImage(named: "placeCheckInViewProfileLine")
////        divider.translatesAutoresizingMaskIntoConstraints = false
////        return divider
////    }()
////
////    let rectangleDivider: UIImageView = {
////        let divider = UIImageView()
////        divider.image = UIImage(named: "rectangleDivider")
////        divider.translatesAutoresizingMaskIntoConstraints = false
////        return divider
////    }()
////
////
//    // 아래로 공간정보
////    let placeNameLable: UILabel = {
////        let label = UILabel()
////        label.text = "노마딕 제주"
////        label.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
////        label.textColor = CustomColor.nomadBlue
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
////
////    let locationLabel: UILabel = {
////        let label = UILabel()
////        label.text = "제주시"
////        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
////        label.textColor = CustomColor.nomadGray1
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
////
////    let locationIcon: UIImageView = {
////        let icon = UIImageView()
////        icon.image = UIImage(named: "locationIcon")
////        icon.translatesAutoresizingMaskIntoConstraints = false
////        return icon
////    }()
////
////    let placeNoteLabel: UILabel = {
////        let label = UILabel()
////        label.text = "인포데스크는 오전 10시 - 오후 4시 사이에만 운영됩니다. (점심시간포함)"
////        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
////        label.translatesAutoresizingMaskIntoConstraints = false
////        return label
////    }()
//
//
//    // 해당 공간에 체크인한 사람
//    private let checkedProfileListView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//
//
//    // MARK: - LifeCycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
////        profileInfoView()
////
////        view.addSubview(rectangleDivider)
////        rectangleDivider.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 211, paddingLeft: 0)
////
////        placeInfoView()
//
//        // checkedProfileListView
//        placeCheckInView()
////        view.addSubview(checkedProfileListView)
////        self.checkedProfileListView.dataSource = self
////        self.checkedProfileListView.delegate = self
////        self.checkedProfileListView.register(CheckedProfileListViewCell.self, forCellWithReuseIdentifier: CheckedProfileListViewCell.identifier)
////
////
////        checkedProfileListView.translatesAutoresizingMaskIntoConstraints = false
////        checkedProfileListView.topAnchor.constraint(equalTo: view.topAnchor, constant: 468).isActive = true
////        checkedProfileListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 17).isActive = true
////        checkedProfileListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
////        checkedProfileListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -17).isActive = true
//
////        view.backgroundColor = .systemBackground
//        view.backgroundColor = CustomColor.nomadGray2
//    }
//
//
//    // MARK: - Helps
//
//    // 컬렉션 뷰 레이아웃
//    func placeCheckInView() {
//        // TODO: view 새로 넣기
//        view.addSubview(checkedProfileListView)
//        self.checkedProfileListView.dataSource = self
//        self.checkedProfileListView.delegate = self
//        self.checkedProfileListView.register(CheckedProfileListViewCell.self, forCellWithReuseIdentifier: CheckedProfileListViewCell.identifier)
//
//
//        checkedProfileListView.translatesAutoresizingMaskIntoConstraints = false
//        checkedProfileListView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        checkedProfileListView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        checkedProfileListView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        checkedProfileListView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//    }
////    func profileInfoView() {
////        // 프로필 이미지
////        view.addSubview(userProfileImg)
////        userProfileImg.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 113, paddingLeft: 26)
////        // 사용자 이름
////        view.addSubview(usernameLabel)
////        usernameLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 121, paddingLeft: 125)
////        // 직업
////        view.addSubview(occupationLabel)
////        occupationLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 130, paddingLeft: 260)
////
////        // 구분선
////        view.addSubview(placeCheckInViewProfileLine)
////        placeCheckInViewProfileLine.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 152, paddingLeft: 125)
////
////        // 상태 메세지
////        view.addSubview(noteLabel)
////        noteLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 158, paddingLeft: 125)
////    }
////
////    func placeInfoView() {
////        // 공간 이름
////        view.addSubview(placeNameLable)
////        placeNameLable.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 235, paddingLeft: 17)
////        // 픽토그램
////        view.addSubview(locationIcon)
////        locationIcon.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 262, paddingLeft: 18)
////        // 소재지
////        view.addSubview(locationLabel)
////        locationLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 261, paddingLeft: 28)
////        // 공지사항
////        view.addSubview(placeNoteLabel)
////        placeNoteLabel.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 285, paddingLeft: 18)
////    }
//}
//
//
//// MARK: - Extentions
//
//extension PlaceCheckInViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 2 {
//            return 10
//        }
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        // check
//        print(indexPath)
////        guard let userProfileCell = CheckedProfileListHeader
//        guard let checkedProfileCell = collectionView.dequeueReusableCell(withReuseIdentifier: CheckedProfileListViewCell.identifier, for: indexPath) as? CheckedProfileListViewCell else {
//            return UICollectionViewCell()
//        }
//
//
//        if indexPath[0] == 0 {
//            checkedProfileCell.backgroundColor = .red
//        } else {
//            checkedProfileCell.backgroundColor = .white
//            checkedProfileCell.layer.borderWidth = 1
//            checkedProfileCell.layer.borderColor = CustomColor.nomadGray2?.cgColor
//            checkedProfileCell.layer.cornerRadius = 12
//            return checkedProfileCell
//        }
//        return checkedProfileCell
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
////        // 섹션의 헤더 너비와 높이 설정
////            let width = collectionView.frame.width
////            let height: CGFloat = 80
////            return CGSize(width: width, height: height)
////    }
//}
//
//
//
//
//
//
//
//extension PlaceCheckInViewController: UICollectionViewDelegateFlowLayout {
//
//    // cell size
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath[0] == 2 {
//            return CGSize(width: 356, height: 85)
//        }
//        return CGSize(width: 400, height: 85)
//    }
//
//    // header
////    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
////        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CheckedProfileListHeader.identifier, for: indexPath) as?  CheckedProfileListHeader else { return UICollectionReusableView() }
////        return header
////    }
//}
//
//
//
//

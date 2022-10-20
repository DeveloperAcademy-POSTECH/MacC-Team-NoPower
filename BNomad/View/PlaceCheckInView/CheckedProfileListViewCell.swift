//
//  CheckedProfileListViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/19.
//

import UIKit

class CheckedProfileListViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CheckedProfileListViewCell"
    
    private let userProfileImg: UIImageView = {
        let userProfileImg = UIImageView()
        userProfileImg.image = UIImage(named: "othersProfile")
        userProfileImg.translatesAutoresizingMaskIntoConstraints = false
        return userProfileImg
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "스미스"
        label.font = .preferredFont(forTextStyle: .title3, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer"
        label.font = .preferredFont(forTextStyle: .title3, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "커피챗 환영합니다:P"
        label.font = .preferredFont(forTextStyle: .title3, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    func render() {
        // 프로필 이미지
        self.addSubview(userProfileImg)
        userProfileImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 17, paddingLeft: 24)
        
        // 사용자 이름
        self.addSubview(usernameLabel)
        usernameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 19, paddingLeft: 102)
        
        // 직업
        self.addSubview(occupationLabel)
        occupationLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 19, paddingLeft: 178)
        
        // 상태 메세지
        self.addSubview(noteLabel)
        noteLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 44, paddingLeft: 102)
    }
}

// cell 1
class userProfileViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "userProfileViewCell"
    
    private let userProfileImg: UIImageView = {
        let userProfileImg = UIImageView()
        userProfileImg.image = UIImage(named: "profileDefault")
        userProfileImg.translatesAutoresizingMaskIntoConstraints = false
        return userProfileImg
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "김노마 (나)"
        label.font = .preferredFont(forTextStyle: .title2, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let occupationLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer"
        label.font = .preferredFont(forTextStyle: .footnote, weight: .semibold)
        label.textColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "커피챗 환영합니다:P"
        label.font = .preferredFont(forTextStyle: .body, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let placeCheckInViewProfileLine: UIImageView = {
        let divider = UIImageView()
        divider.image = UIImage(named: "placeCheckInViewProfileLine")
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    private let rectangleDivider: UIImageView = {
        let divider = UIImageView()
        divider.image = UIImage(named: "rectangleDivider")
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    func render() {
        // 프로필 이미지
        self.addSubview(userProfileImg)
        userProfileImg.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 53, paddingLeft: 26)
        // 사용자 이름
        self.addSubview(usernameLabel)
        usernameLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 71, paddingLeft: 125)
        // 직업
        self.addSubview(occupationLabel)
        occupationLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 80, paddingLeft: 260)

        // 구분선
        self.addSubview(placeCheckInViewProfileLine)
        placeCheckInViewProfileLine.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 102, paddingLeft: 125)

        // 상태 메세지
        self.addSubview(noteLabel)
        noteLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 108, paddingLeft: 125)
        
        // 구분선
        // TODO: collectionView 안에서 해결하기
        self.addSubview(rectangleDivider)
        rectangleDivider.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 152, paddingLeft: 0)
        
    }
}


// cell 2
class placeInforViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "placeInforViewCell"
    
    private let placeNameLable: UILabel = {
        let label = UILabel()
        label.text = "노마딕 제주"
        label.font = .preferredFont(forTextStyle: .subheadline, weight: .semibold)
        label.textColor = CustomColor.nomadBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "제주시"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.textColor = CustomColor.nomadGray1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let locationIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = UIImage(named: "locationIcon")
        icon.translatesAutoresizingMaskIntoConstraints = false
        return icon
    }()

    private let placeNoteLabel: UILabel = {
        let label = UILabel()
        label.text = "인포데스크는 오전 10시 - 오후 4시 사이에만 운영됩니다. (점심시간포함)"
        label.font = .preferredFont(forTextStyle: .caption2, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(corder:) has not been implemented")
    }
    
    func render() {
        // 공간 이름
        self.addSubview(placeNameLable)
        placeNameLable.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 10, paddingLeft: 17)
        // 픽토그램
        self.addSubview(locationIcon)
        locationIcon.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 37, paddingLeft: 18)
        // 소재지
        self.addSubview(locationLabel)
        locationLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 36, paddingLeft: 28)
        // 공지사항
        self.addSubview(placeNoteLabel)
        placeNoteLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 18)
    }
    
}




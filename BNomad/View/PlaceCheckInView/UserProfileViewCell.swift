//
//  UserProfileViewCell.swift
//  BNomad
//
//  Created by yeekim on 2022/10/20.
//

import UIKit

class UserProfileViewCell: UICollectionViewCell {
    
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
    
    // MARK: - Helpers
    
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
        
    }
}

//
//  ReviewSubCell2.swift
//  BNomad
//
//  Created by 유재훈 on 2022/11/10.
//

import UIKit

class ReviewSubCell2: UICollectionViewCell {
    static let cellIdentifier = "ReviewSubCell2"
    
    // MARK: - Properties
    
    
    lazy var reviewTextLabel: UILabel = {
        let reviewTextLabel = UILabel()
        reviewTextLabel.text = "한줄 소개 입니다. 오늘 소맥 고 하나요"
        reviewTextLabel.textColor = CustomColor.nomadBlack
        reviewTextLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return reviewTextLabel
    }()
    
    var reviewImageView: UIImageView = {
        let reviewImageView = UIImageView()
        reviewImageView.image = UIImage(named: "ReviewPhoto")
        return reviewImageView
    }()
    
    var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        
        return profileImageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.text = "하이로, 개발자"
        userNameLabel.textColor = CustomColor.nomadGray1
        userNameLabel.font = .preferredFont(forTextStyle: .caption1, weight: .regular)
        return userNameLabel
    }()

    
    // MARK: - Lifecycle
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        self.addSubview(reviewTextLabel)
        self.addSubview(reviewImageView)
        self.addSubview(profileImageView)
        self.addSubview(userNameLabel)
        setAttributes()
    }
    
    private func setAttributes() {
        reviewTextLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 11, paddingLeft: 7)
        NSLayoutConstraint.activate([
            reviewImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
            ])
        reviewImageView.anchor(right: self.rightAnchor, paddingRight: 7, width: 60, height: 60)
        profileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 38, paddingLeft: 7, width: 20, height: 20)
        userNameLabel.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, paddingTop: 41, paddingLeft: 8)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

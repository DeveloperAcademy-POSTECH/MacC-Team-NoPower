//
//  ReviewSubCell.swift
//  BNomad
//
//  Created by 유재훈 on 2022/11/09.
//

import UIKit
import Kingfisher

class ReviewSubCell: UICollectionViewCell {
    static let cellIdentifier = "ReviewSubCell"
    
    // MARK: - Properties
    
    var review: Review? {
        didSet {
            guard let review = review else { return }
            
            FirebaseManager.shared.fetchUser(id: review.userUid) { user in
                self.userNameLabel.text = user.nickname
                if let profileImageUrl = user.profileImageUrl {
                    self.profileImageView.kf.setImage(with: URL(string: profileImageUrl))
                }
            }
            if let reviewImageUrl = review.imageUrl {
                reviewImageView.kf.setImage(with: URL(string: reviewImageUrl))
            } else {
                reviewImageView.image = UIImage()
            }
            
            reviewTextLabel.text = review.content
        }
    }
    
    lazy var reviewTextLabel: UILabel = {
        let reviewTextLabel = UILabel()
        reviewTextLabel.textColor = CustomColor.nomadBlack
        reviewTextLabel.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        return reviewTextLabel
    }()
    
    var reviewImageView: UIImageView = {
        let reviewImageView = UIImageView()
        reviewImageView.layer.cornerRadius = 5
        reviewImageView.clipsToBounds = true
        reviewImageView.contentMode = .scaleAspectFill
        return reviewImageView
    }()
    
    var profileImageView = ProfileUIImageView(widthRatio: 20)
    
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = CustomColor.nomadGray1
        userNameLabel.font = .preferredFont(forTextStyle: .caption1, weight: .regular)
        return userNameLabel
    }()
    
    let horizontalDivider1: UILabel = {
        let horizontalDivider1 = UILabel()
        horizontalDivider1.backgroundColor = CustomColor.nomad2Separator
        return horizontalDivider1
    }()

    
    // MARK: - Lifecycle
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        self.addSubview(reviewTextLabel)
        self.addSubview(reviewImageView)
        self.addSubview(profileImageView)
        self.addSubview(userNameLabel)
        self.addSubview(horizontalDivider1)
        setAttributes()
    }
    
    private func setAttributes() {
        reviewTextLabel.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 7)
        reviewImageView.centerY(inView: self)
        reviewImageView.anchor(right: self.rightAnchor, paddingRight: 7, width: 60, height: 60)
        profileImageView.anchor(top: reviewTextLabel.bottomAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 7, width: 20, height: 20)
        userNameLabel.anchor(top: reviewTextLabel.bottomAnchor, left: profileImageView.rightAnchor, paddingTop: 10, paddingLeft: 8)
        horizontalDivider1.anchor(top: reviewImageView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 4, paddingLeft: 3, paddingRight: 3, height: 1)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
                } else {
                    self.profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
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
        return reviewImageView
    }()
    
    var profileImageView: UIImageView = {
        let profileImageView = UIImageView()        
        return profileImageView
    }()
    
    lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
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

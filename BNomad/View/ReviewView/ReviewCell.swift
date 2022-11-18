//
//  ReviewCell.swift
//  BNomad
//
//  Created by 박진웅 on 2022/11/07.
//

import UIKit
import Kingfisher

class ReviewCell: UICollectionViewCell {
    
    static let identifier = "ReviewCell"

    // MARK: - Properties
    
    var review: Review? {
        didSet {
            guard let review = review else { return }
            self.reviewText.text = review.content
            if let imageString = review.imageUrl {
                self.photo.isHidden = false
                self.photo.anchor(top: divider.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20, height: 174)
                self.photo.kf.setImage(with: URL(string: imageString))
            } else {
                self.photo.isHidden = true
                self.reviewText.anchor(top: self.divider.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 12, paddingLeft: 21, paddingRight: 22)
            }
            FirebaseManager.shared.fetchUser(id: review.userUid) { user in
                self.userName.text = user.nickname
                if let userImageUrl = user.profileImageUrl {
                    self.userImage.kf.setImage(with: URL(string: userImageUrl))
                }
            }
        }
    }
    
    var divider: UIView = {
        let rectangle = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        rectangle.backgroundColor = UIColor(hex: "D3D3D3")
        return rectangle
    }()

    var photo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    var reviewText: UILabel = {
        let text = UILabel()
        text.backgroundColor = .clear
        text.textColor = .black
        text.font = .preferredFont(forTextStyle: .subheadline, weight: .regular)
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.text = ""
        text.textAlignment = .left
        return text
    }()

    private var userImage: UIImageView = {
        let image = UIImage(named: "AppIcon")
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = imageView.bounds.width/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var userName: UILabel = {
        let text = UILabel()
        text.backgroundColor = .clear
        text.textColor = CustomColor.nomadGray1
        text.font = .preferredFont(forTextStyle: .caption1, weight: .regular)
        text.text = "랑스, 개발자"
        text.textAlignment = .center
        return text
    }()
    
    // MARK: - LifeCycle
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.anchor(top: contentView.topAnchor, width: UIScreen.main.bounds.width)
        self.backgroundColor = .white
        self.addSubview(divider)
        self.addSubview(reviewText)
        self.addSubview(userImage)
        self.addSubview(userName)

        self.addSubview(photo)

        divider.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingRight: 0, height: 0.5)
        userImage.anchor(top: reviewText.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, paddingTop: 4, paddingLeft: 21, paddingBottom: 11, width: 20, height: 20)
        userName.centerY(inView: userImage, leftAnchor: userImage.rightAnchor, paddingLeft: 8)
        photo.anchor(top: divider.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingRight: 20, height: 174)
        reviewText.anchor(top: photo.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 21, paddingRight: 22)
    }

}
